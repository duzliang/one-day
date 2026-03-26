/**
 * 天气信息接口
 */
export interface WeatherInfo {
  condition: string;  // sunny, cloudy, rainy, snowy, windy
  temperature: number;
  humidity?: number;
  city?: string;
}

/**
 * 日记条目接口
 */
export interface DiaryEntry {
  id: number;
  title: string;
  content: string;
  createdAt: Date;
  updatedAt: Date;
  weather?: WeatherInfo;
  location?: {
    name: string;
    latitude: number;
    longitude: number;
  };
  photos: string[];  // 照片路径数组
  tags: string[];
  isFavorite: boolean;
}

/**
 * 日记管理器 - 单例模式
 */
export class DiaryManager {
  private static instance: DiaryManager;
  private entries: DiaryEntry[] = [];
  private nextId: number = 1;

  private constructor() {
    this.loadEntries();
  }

  static getInstance(): DiaryManager {
    if (!DiaryManager.instance) {
      DiaryManager.instance = new DiaryManager();
    }
    return DiaryManager.instance;
  }

  /**
   * 加载日记列表
   */
  async loadEntries() {
    try {
      const data = await preferences.getPreferencesSync('diary_data');
      const json = data.get('entries') as string;
      if (json) {
        const parsed = JSON.parse(json);
        this.entries = parsed.map((e: any) => ({
          ...e,
          createdAt: new Date(e.createdAt),
          updatedAt: new Date(e.updatedAt)
        }));
        this.nextId = data.get('nextId') as number || 1;
      }
    } catch (e) {
      console.info('No existing diary data');
    }
  }

  /**
   * 保存日记列表到本地
   */
  async saveEntries() {
    try {
      const data = await preferences.getPreferencesSync('diary_data');
      const json = JSON.stringify(this.entries);
      data.put('entries', json);
      data.put('nextId', this.nextId);
      await data.flush();
    } catch (e) {
      console.error('Failed to save diary data', e);
    }
  }

  /**
   * 获取所有日记，按创建时间倒序
   */
  getAllEntries(): DiaryEntry[] {
    return [...this.entries].sort((a, b) =>
      new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime()
    );
  }

  /**
   * 根据 ID 获取日记
   */
  getEntryById(id: number): DiaryEntry | undefined {
    return this.entries.find(e => e.id === id);
  }

  /**
   * 创建新日记
   */
  createEntry(partial: Partial<DiaryEntry>): DiaryEntry {
    const now = new Date();
    const entry: DiaryEntry = {
      id: this.nextId++,
      title: partial.title || '',
      content: partial.content || '',
      createdAt: now,
      updatedAt: now,
      weather: partial.weather,
      location: partial.location,
      photos: partial.photos || [],
      tags: partial.tags || [],
      isFavorite: partial.isFavorite || false
    };
    this.entries.push(entry);
    this.saveEntries();
    return entry;
  }

  /**
   * 更新日记
   */
  updateEntry(id: number, updates: Partial<DiaryEntry>): DiaryEntry | undefined {
    const index = this.entries.findIndex(e => e.id === id);
    if (index === -1) return undefined;

    this.entries[index] = {
      ...this.entries[index],
      ...updates,
      id,  // 不允许修改 ID
      createdAt: this.entries[index].createdAt,  // 不允许修改创建时间
      updatedAt: new Date()
    };
    this.saveEntries();
    return this.entries[index];
  }

  /**
   * 删除日记
   */
  deleteEntry(id: number): boolean {
    const index = this.entries.findIndex(e => e.id === id);
    if (index === -1) return false;
    this.entries.splice(index, 1);
    this.saveEntries();
    return true;
  }

  /**
   * 获取指定日期的日记
   */
  getEntryByDate(date: Date): DiaryEntry | undefined {
    const targetDate = date.toDateString();
    return this.entries.find(e => e.createdAt.toDateString() === targetDate);
  }

  /**
   * 获取收藏的日记
   */
  getFavoriteEntries(): DiaryEntry[] {
    return this.entries.filter(e => e.isFavorite);
  }

  /**
   * 搜索日记
   */
  searchEntries(query: string): DiaryEntry[] {
    const lowerQuery = query.toLowerCase();
    return this.entries.filter(entry =>
      entry.title.toLowerCase().includes(lowerQuery) ||
      entry.content.toLowerCase().includes(lowerQuery) ||
      entry.tags.some(tag => tag.toLowerCase().includes(lowerQuery))
    );
  }
}
