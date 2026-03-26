import { WeatherInfo } from '../models/DiaryEntry';

/**
 * 天气工具类
 * 模拟获取天气信息（实际应用中需要接入天气 API）
 */
export class WeatherUtil {
  private static readonly WEATHER_CONDITIONS = [
    'sunny', 'cloudy', 'rainy', 'snowy', 'windy'
  ];

  /**
   * 获取当前天气（模拟数据）
   * 实际应用中应该调用天气 API
   */
  static async getCurrentWeather(): Promise<WeatherInfo | null> {
    // 模拟 API 调用延迟
    await new Promise(resolve => setTimeout(resolve, 500));

    // 这里返回模拟数据，实际应该调用天气 API
    // 例如：https://api.openweathermap.org/data/2.5/weather
    const conditions = ['sunny', 'cloudy', 'rainy', 'snowy', 'windy'];
    const randomCondition = conditions[Math.floor(Math.random() * conditions.length)];
    const randomTemp = Math.floor(Math.random() * 35) - 5;  // -5 到 30 度

    return {
      condition: randomCondition,
      temperature: randomTemp,
      humidity: Math.floor(Math.random() * 50) + 30,  // 30-80%
      city: '北京'
    };
  }

  /**
   * 根据日期获取历史天气（模拟）
   */
  static async getHistoricalWeather(date: Date): Promise<WeatherInfo | null> {
    await new Promise(resolve => setTimeout(resolve, 300));

    const conditions = ['sunny', 'cloudy', 'rainy', 'snowy', 'windy'];
    const seed = date.getDate() + date.getMonth();
    const condition = conditions[seed % conditions.length];
    const temp = 15 + Math.sin(seed) * 10;

    return {
      condition: condition,
      temperature: Math.floor(temp),
      city: '北京'
    };
  }

  /**
   * 获取天气图标
   */
  static getWeatherIcon(condition: string): string {
    const icons: Record<string, string> = {
      'sunny': '☀️',
      'cloudy': '☁️',
      'rainy': '🌧️',
      'snowy': '❄️',
      'windy': '💨',
      'thunderstorm': '⛈️',
      'foggy': '🌫️'
    };
    return icons[condition] || '🌤️';
  }

  /**
   * 获取天气描述
   */
  static getWeatherDescription(condition: string, temperature: number): string {
    const descriptions: Record<string, string> = {
      'sunny': '晴朗',
      'cloudy': '多云',
      'rainy': '下雨',
      'snowy': '下雪',
      'windy': '有风',
      'thunderstorm': '雷雨',
      'foggy': '有雾'
    };
    const desc = descriptions[condition] || '未知';
    return `${desc} ${temperature}°C`;
  }

  /**
   * 获取天气颜色
   */
  static getWeatherColor(condition: string): string {
    const colors: Record<string, string> = {
      'sunny': '#FF9500',
      'cloudy': '#8E8E93',
      'rainy': '#007AFF',
      'snowy': '#5AC8FA',
      'windy': '#34C759',
      'thunderstorm': '#FF3B30',
      'foggy': '#C7C7CC'
    };
    return colors[condition] || '#8E8E93';
  }
}
