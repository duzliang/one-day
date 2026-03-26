import { DiaryEntry, DiaryManager } from '../models/DiaryEntry';
import { WeatherInfo } from '../utils/WeatherUtil';

@Entry
@Component
struct Index {
  @State diaryEntries: DiaryEntry[] = [];
  @State selectedIndex: number = -1;
  @State showSearch: boolean = false;
  @State searchText: string = '';
  @State selectedTab: number = 0;

  aboutToAppear() {
    this.loadDiaries();
  }

  loadDiaries() {
    this.diaryEntries = DiaryManager.getInstance().getAllEntries();
  }

  @Builder
  diaryCard(entry: DiaryEntry, index: number) {
    Column() {
      Row() {
        // 日期区域
        Column() {
          Text(this.getWeekDay(entry.createdAt))
            .fontSize(12)
            .fontColor('#8E8E93')
          Text(this.getDayDate(entry.createdAt))
            .fontSize(24)
            .fontWeight(FontWeight.Medium)
            .fontColor('#1C1C1E')
        }
        .width(60)
        .alignItems(HorizontalAlign.Center)
        .margin({ right: 12 })

        // 内容区域
        Column() {
          Row() {
            if (entry.title && entry.title.trim() !== '') {
              Text(entry.title)
                .fontSize(16)
                .fontWeight(FontWeight.SemiBold)
                .fontColor('#1C1C1E')
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
            }

            if (entry.weather) {
              Text(this.getWeatherIcon(entry.weather))
                .fontSize(20)
                .margin({ left: 8 })
            }

            if (entry.location) {
              Text('📍')
                .fontSize(16)
                .margin({ left: 8 })
            }

            if (entry.photos && entry.photos.length > 0) {
              Text('📷')
                .fontSize(16)
                .margin({ left: 8 })
            }
          }
          .width('100%')

          Text(entry.content.substring(0, 50) + (entry.content.length > 50 ? '...' : ''))
            .fontSize(14)
            .fontColor('#8E8E93')
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .margin({ top: 4 })
            .width('100%')
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)

        // 编辑按钮
        Button() {
          Text('›')
            .fontSize(20)
            .fontColor('#C7C7CC')
        }
        .type(ButtonType.Circle)
        .backgroundColor(Color.Transparent)
        .onClick(() => {
          router.pushUrl({
            url: 'pages/EditPage',
            params: { entryId: entry.id }
          });
        })
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#FFFFFF')
      .borderRadius(12)
      .shadow({
        radius: 4,
        color: 'rgba(0,0,0,0.05)',
        offsetX: 0,
        offsetY: 1
      })
    }
    .width('100%')
    .onClick(() => {
      router.pushUrl({
        url: 'pages/DetailPage',
        params: { entryId: entry.id }
      });
    })
  }

  getWeekDay(date: Date): string {
    const weekDays = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];
    return weekDays[new Date(date).getDay()];
  }

  getDayDate(date: Date): string {
    const d = new Date(date);
    const month = d.getMonth() + 1;
    const day = d.getDate();
    return `${month}月${day}日`;
  }

  getWeatherIcon(weather: WeatherInfo): string {
    const icons: Record<string, string> = {
      'sunny': '☀️',
      'cloudy': '☁️',
      'rainy': '🌧️',
      'snowy': '❄️',
      'windy': '💨'
    };
    return icons[weather.condition] || '🌤️';
  }

  getFilteredEntries(): DiaryEntry[] {
    if (this.searchText.trim() === '') {
      return this.diaryEntries;
    }
    const search = this.searchText.toLowerCase();
    return this.diaryEntries.filter(entry =>
      entry.title.toLowerCase().includes(search) ||
      entry.content.toLowerCase().includes(search)
    );
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Text('OneDay')
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1C1C1E')

        Blank()

        Button() {
          Image($r('sys.media.ohos_ic_public_search'))
            .width(24)
            .height(24)
        }
        .type(ButtonType.Circle)
        .backgroundColor(Color.Transparent)
        .onClick(() => {
          this.showSearch = !this.showSearch;
        })

        Button() {
          Image($r('sys.media.ohos_ic_public_add'))
            .width(24)
            .height(24)
        }
        .type(ButtonType.Circle)
        .backgroundColor('#007AFF')
        .margin({ left: 12 })
        .onClick(() => {
          router.pushUrl({
            url: 'pages/EditPage',
            params: { entryId: -1 }
          });
        })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 12, bottom: 12 })

      // 搜索框
      if (this.showSearch) {
        Row() {
          Image($r('sys.media.ohos_ic_public_search'))
            .width(20)
            .height(20)
            .margin({ left: 12 })

          TextInput({
            placeholder: '搜索日记...',
            controller: new TextController()
          })
            .layoutWeight(1)
            .backgroundColor('#F2F2F7')
            .borderRadius(8)
            .margin({ left: 8, right: 12, top: 4, bottom: 4 })
            .onChange((value) => {
              this.searchText = value;
            })
        }
        .width('100%')
        .padding({ left: 8, right: 8, bottom: 8 })
      }

      // 日记列表
      if (this.getFilteredEntries().length === 0) {
        Column() {
          Text('📝')
            .fontSize(64)
            .margin({ bottom: 16 })
          Text(this.searchText ? '没有找到相关日记' : '还没有日记，开始写一篇吧')
            .fontSize(16)
            .fontColor('#8E8E93')
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .layoutWeight(1)
      } else {
        List() {
          ForEach(this.getFilteredEntries(), (entry: DiaryEntry, index: number) => {
            ListItem() {
              this.diaryCard(entry, index)
            }
            .shadow({ radius: 0, color: 'transparent', offsetX: 0, offsetY: 0 })
            .margin({ bottom: 8 })
          }, (entry: DiaryEntry) => entry.id)
        }
        .layoutWeight(1)
        .padding({ left: 16, right: 16 })
      }

      // 底部标签栏
      Row() {
        Column() {
          Text('📔')
            .fontSize(24)
          Text('日记')
            .fontSize(12)
            .fontColor(this.selectedTab === 0 ? '#007AFF' : '#8E8E93')
        }
        .layoutWeight(1)
        .onClick(() => { this.selectedTab = 0; })

        Column() {
          Text('📷')
            .fontSize(24)
          Text('照片')
            .fontSize(12)
            .fontColor(this.selectedTab === 1 ? '#007AFF' : '#8E8E93')
        }
        .layoutWeight(1)
        .onClick(() => { this.selectedTab = 1; })

        Column() {
          Text('⚙️')
            .fontSize(24)
          Text('设置')
            .fontSize(12)
            .fontColor(this.selectedTab === 2 ? '#007AFF' : '#8E8E93')
        }
        .layoutWeight(1)
        .onClick(() => {
          router.pushUrl({ url: 'pages/SettingsPage' });
        })
      }
      .width('100%')
      .height(60)
      .backgroundColor('#FFFFFF')
      .justifyContent(FlexAlign.SpaceAround)
      .border({ width: { top: 0.5 }, color: '#E5E5EA' })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F2F2F7')
  }
}
