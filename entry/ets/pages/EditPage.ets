import { DiaryEntry, DiaryManager } from '../models/DiaryEntry';
import { WeatherUtil, WeatherInfo } from '../utils/WeatherUtil';
import { LocationUtil, LocationInfo } from '../utils/LocationUtil';

@Entry
@Component
struct EditPage {
  @State title: string = '';
  @State content: string = '';
  @State weather: WeatherInfo | null = null;
  @State location: LocationInfo | null = null;
  @State photos: string[] = [];
  @State isFavorite: boolean = false;
  @State showWeatherPicker: boolean = false;
  @State showLocationPicker: boolean = false;
  @State isLoadingWeather: boolean = false;
  @State isLoadingLocation: boolean = false;

  private entryId: number = -1;
  private diaryManager: DiaryManager = DiaryManager.getInstance();
  private textController: TextController = new TextController();

  aboutToAppear() {
    const params = router.getParams() as Record<string, string>;
    this.entryId = params['entryId'] ? parseInt(params['entryId']) : -1;

    if (this.entryId > 0) {
      this.loadEntry();
    } else {
      this.autoFillWeatherAndLocation();
    }
  }

  loadEntry() {
    const entry = this.diaryManager.getEntryById(this.entryId);
    if (entry) {
      this.title = entry.title || '';
      this.content = entry.content || '';
      this.weather = entry.weather || null;
      this.location = entry.location ? {
        latitude: entry.location.latitude,
        longitude: entry.location.longitude,
        address: entry.location.name,
        city: entry.location.name,
        district: ''
      } : null;
      this.photos = entry.photos || [];
      this.isFavorite = entry.isFavorite || false;
    }
  }

  async autoFillWeatherAndLocation() {
    // 自动获取天气
    this.isLoadingWeather = true;
    const weatherData = await WeatherUtil.getCurrentWeather();
    this.weather = weatherData;
    this.isLoadingWeather = false;

    // 自动获取位置
    this.isLoadingLocation = true;
    const locationData = await LocationUtil.getCurrentLocation();
    if (locationData) {
      const address = await LocationUtil.getAddressFromCoords(
        locationData.latitude,
        locationData.longitude
      );
      this.location = {
        ...locationData,
        address: address,
        city: address.split('市')[0] + '市',
        district: ''
      };
    }
    this.isLoadingLocation = false;
  }

  saveEntry() {
    if (this.content.trim() === '' && this.title.trim() === '') {
      // 空日记不保存
      router.back();
      return;
    }

    const locationData = this.location ? {
      name: this.location.address || '未知位置',
      latitude: this.location.latitude,
      longitude: this.location.longitude
    } : undefined;

    if (this.entryId > 0) {
      // 更新现有日记
      this.diaryManager.updateEntry(this.entryId, {
        title: this.title,
        content: this.content,
        weather: this.weather || undefined,
        location: locationData,
        photos: this.photos,
        isFavorite: this.isFavorite
      });
    } else {
      // 创建新日记
      this.diaryManager.createEntry({
        title: this.title,
        content: this.content,
        weather: this.weather || undefined,
        location: locationData,
        photos: this.photos,
        isFavorite: this.isFavorite
      });
    }

    router.back();
  }

  deleteEntry() {
    if (this.entryId > 0) {
      this.diaryManager.deleteEntry(this.entryId);
      router.back();
    }
  }

  @Builder
  weatherBadge() {
    Row() {
      if (this.isLoadingWeather) {
        LoadingProgress()
          .width(16)
          .height(16)
      } else if (this.weather) {
        Text(WeatherUtil.getWeatherIcon(this.weather.condition))
          .fontSize(16)
        Text(WeatherUtil.getWeatherDescription(
          this.weather.condition,
          this.weather.temperature
        ))
          .fontSize(12)
          .fontColor('#8E8E93')
          .margin({ left: 4 })
      } else {
        Text('添加天气')
          .fontSize(12)
          .fontColor('#007AFF')
      }
    }
    .padding({ left: 12, right: 12, top: 6, bottom: 6 })
    .backgroundColor(this.weather ? '#F2F2F7' : '#E8F4FD')
    .borderRadius(16)
    .onClick(() => {
      if (!this.weather) {
        this.showWeatherPicker = true;
      }
    })
  }

  @Builder
  locationBadge() {
    Row() {
      if (this.isLoadingLocation) {
        LoadingProgress()
          .width(16)
          .height(16)
      } else if (this.location) {
        Text('📍')
          .fontSize(16)
        Text(this.location.address || '未知位置')
          .fontSize(12)
          .fontColor('#8E8E93')
          .margin({ left: 4 })
      } else {
        Text('添加位置')
          .fontSize(12)
          .fontColor('#007AFF')
      }
    }
    .padding({ left: 12, right: 12, top: 6, bottom: 6 })
    .backgroundColor(this.location ? '#F2F2F7' : '#E8F4FD')
    .borderRadius(16)
    .onClick(async () => {
      if (!this.location) {
        this.isLoadingLocation = true;
        const loc = await LocationUtil.getFullLocation();
        this.location = loc;
        this.isLoadingLocation = false;
      }
    })
  }

  @Builder
  photoStrip() {
    if (this.photos.length === 0) {
      return;
    }

    Row() {
      ForEach(this.photos, (photo: string, index: number) => {
        Image(photo)
          .width(80)
          .height(80)
          .objectFit(ImageFit.Cover)
          .borderRadius(8)
          .onClick(() => {
            // 预览或删除照片
            this.photos.splice(index, 1);
          })
      }, (photo: string, index: number) => index)

      // 添加照片按钮
      Button() {
        Text('+')
          .fontSize(24)
          .fontColor('#007AFF')
      }
      .width(80)
      .height(80)
      .backgroundColor('#F2F2F7')
      .borderRadius(8)
      .onClick(() => {
        // TODO: 打开相册或相机
      })
    }
    .width('100%')
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Button() {
          Text('取消')
            .fontSize(16)
            .fontColor('#007AFF')
        }
        .type(ButtonType.Plain)
        .onClick(() => {
          router.back();
        })

        Text(this.entryId > 0 ? '编辑日记' : '新建日记')
          .fontSize(17)
          .fontWeight(FontWeight.Medium)
          .fontColor('#1C1C1E')

        Button() {
          Text('保存')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor('#007AFF')
        }
        .type(ButtonType.Plain)
        .onClick(() => {
          this.saveEntry();
        })
      }
      .width('100%')
      .padding({ left: 12, right: 12, top: 12, bottom: 12 })
      .justifyContent(FlexAlign.SpaceBetween)

      Divider()
        .color('#E5E5EA')

      // 滚动内容区
      Scroll() {
        Column() {
          // 日期显示
          Row() {
            Text(this.getFormattedDate())
              .fontSize(14)
              .fontColor('#8E8E93')
          }
          .width('100%')
          .padding({ left: 16, right: 16, top: 12, bottom: 8 })

          // 标题输入
          TextInput({
            placeholder: '标题（可选）',
            controller: new TextController()
          })
            .width('100%')
            .backgroundColor(Color.Transparent)
            .fontSize(20)
            .fontWeight(FontWeight.SemiBold)
            .padding({ left: 16, right: 16 })
            .onChange((value) => {
              this.title = value;
            })
            .bindController(this.textController)

          // 天气和位置标签
          Row() {
            this.weatherBadge()
              .margin({ right: 8 })
            this.locationBadge()

            // 收藏按钮
            Button() {
              Text(this.isFavorite ? '❤️' : '🤍')
                .fontSize(18)
            }
            .type(ButtonType.Circle)
            .backgroundColor(Color.Transparent)
            .margin({ left: 'auto' })
            .onClick(() => {
              this.isFavorite = !this.isFavorite;
            })
          }
          .width('100%')
          .padding({ left: 16, right: 16, top: 12, bottom: 8 })

          Divider()
            .color('#E5E5EA')
            .margin({ left: 16, right: 16 })

          // 照片区域
          if (this.photos.length > 0) {
            this.photoStrip()
              .padding({ left: 16, right: 16, top: 12 })
          }

          // 内容输入
          TextArea({
            placeholder: '写下今天的故事...',
            controller: new TextController()
          })
            .width('100%')
            .height(400)
            .backgroundColor(Color.Transparent)
            .fontSize(16)
            .lineHeight(26)
            .padding(16)
            .onChange((value) => {
              this.content = value;
            })

          // 添加照片按钮
          Row() {
            Button() {
              Column() {
                Text('📷')
                  .fontSize(24)
                Text('添加照片')
                  .fontSize(12)
                  .fontColor('#007AFF')
              }
            }
            .backgroundColor('#F2F2F7')
            .borderRadius(12)
            .padding({ left: 20, right: 20, top: 12, bottom: 12 })
            .onClick(() => {
              // TODO: 打开相册
              this.photos.push('temp_photo');  // 模拟
            })
          }
          .width('100%')
          .padding({ left: 16, right: 16, top: 12 })
          .justifyContent(FlexAlign.Start)
        }
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)

      // 删除按钮（仅编辑模式）
      if (this.entryId > 0) {
        Button() {
          Text('删除日记')
            .fontSize(16)
            .fontColor('#FF3B30')
        }
        .width('100%')
        .height(50)
        .backgroundColor('#FFF0F0')
        .borderRadius(12)
        .margin({ left: 16, right: 16, bottom: 16 })
        .onClick(() => {
          this.deleteEntry();
        })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }

  getFormattedDate(): string {
    const now = new Date();
    const year = now.getFullYear();
    const month = now.getMonth() + 1;
    const day = now.getDate();
    const weekDays = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];
    const weekDay = weekDays[now.getDay()];
    return `${year}年${month}月${day}日 ${weekDay}`;
  }
}
