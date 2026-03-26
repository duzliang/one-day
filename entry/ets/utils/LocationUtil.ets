import { geoLocationManager } from '@kit.CoreFileKit';
import { BusinessError } from '@kit.BasicServicesKit';

/**
 * 位置信息接口
 */
export interface LocationInfo {
  latitude: number;
  longitude: number;
  altitude?: number;
  address?: string;
  city?: string;
  district?: string;
}

/**
 * 位置工具类
 */
export class LocationUtil {
  private static isRequesting: boolean = false;

  /**
   * 获取当前位置
   */
  static async getCurrentLocation(): Promise<LocationInfo | null> {
    if (this.isRequesting) {
      return null;
    }

    return new Promise((resolve) => {
      this.isRequesting = true;

      try {
        // 使用 HarmonyOS 的地理位置服务
        geoLocationManager.getCurrentLocation(
          { priority: 0 },  // 优先级：0 表示平衡精度和功耗
          (location: geoLocationManager.Location) => {
            this.isRequesting = false;
            resolve({
              latitude: location.latitude,
              longitude: location.longitude,
              altitude: location.altitude
            });
          },
          (error: BusinessError) => {
            this.isRequesting = false;
            console.error('Failed to get location', error);
            resolve(null);
          }
        );
      } catch (e) {
        this.isRequesting = false;
        console.error('Location error', e);
        resolve(null);
      }
    });
  }

  /**
   * 根据经纬度获取地址（模拟反向地理编码）
   * 实际应用中需要接入地图 API
   */
  static async getAddressFromCoords(
    latitude: number,
    longitude: number
  ): Promise<string> {
    // 模拟 API 调用
    await new Promise(resolve => setTimeout(resolve, 300));

    // 这里应该调用反向地理编码 API
    // 例如高德地图、百度地图或 Google Maps 的 API
    const mockAddresses = [
      '北京市朝阳区',
      '北京市海淀区',
      '北京市东城区',
      '北京市西城区',
      '上海市浦东新区',
      '深圳市南山区',
      '广州市天河区'
    ];
    const index = Math.floor((Math.abs(latitude + longitude)) % mockAddresses.length);
    return mockAddresses[index];
  }

  /**
   * 获取完整位置信息
   */
  static async getFullLocation(): Promise<LocationInfo | null> {
    const location = await this.getCurrentLocation();
    if (!location) {
      return null;
    }

    const address = await this.getAddressFromCoords(
      location.latitude,
      location.longitude
    );

    // 简单解析地址
    const parts = address.split('');
    let city = '';
    let district = '';

    if (address.includes('市')) {
      const cityIndex = address.indexOf('市');
      city = address.substring(0, cityIndex + 1);
      const rest = address.substring(cityIndex + 1);
      if (rest.includes('区')) {
        const districtIndex = rest.indexOf('区');
        district = rest.substring(0, districtIndex + 1);
      }
    }

    return {
      ...location,
      address: address,
      city: city,
      district: district
    };
  }

  /**
   * 计算两个位置之间的距离（单位：公里）
   */
  static calculateDistance(
    lat1: number,
    lon1: number,
    lat2: number,
    lon2: number
  ): number {
    const R = 6371;  // 地球半径（公里）
    const dLat = this.toRad(lat2 - lat1);
    const dLon = this.toRad(lon2 - lon1);
    const a =
      Math.sin(dLat / 2) * Math.sin(dLat / 2) +
      Math.cos(this.toRad(lat1)) * Math.cos(this.toRad(lat2)) *
      Math.sin(dLon / 2) * Math.sin(dLon / 2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    return R * c;
  }

  private static toRad(degrees: number): number {
    return degrees * Math.PI / 180;
  }

  /**
   * 检查位置权限
   */
  static async checkPermission(): Promise<boolean> {
    // 实际应用中需要检查位置权限
    // 这里简化处理
    return true;
  }
}
