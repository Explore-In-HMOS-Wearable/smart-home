import { lang } from '@kit.ArkTS';
import { backgroundTaskManager } from '@kit.BackgroundTasksKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { AppData } from './AppData';
import { AppStorageV2 } from '@kit.ArkUI';

@ObservedV2
export class RoomItemModel {
  id: number = 0;
  @Trace name: string = '';
  @Trace isEnabled: boolean = false;
  @Trace roomLightColor: string = 'White';
  @Trace roomBrightness: number = 50;
  @Trace roomSleepAfter: 0 | 5 | 15 | 30 = 0;
  @Trace icon: string = 'app.media.livingRoomActive'
  roomItemSendable: RoomItemSendable;

  constructor(
    name: string,
    icon?: string,
    isEnabled: boolean = false,
    id?: number,
    brightness?: number,
    roomLightColor?: string,
  ) {
    this.id = id ? id : Date.now();
    this.name = name;
    this.isEnabled = isEnabled;
    this.roomBrightness = brightness ?? 50;
    this.icon = icon ?? 'app.media.livingRoomActive';
    this.roomLightColor = roomLightColor ?? 'White';
    this.roomItemSendable = new RoomItemSendable(
      this.id,
      this.name,
      this.isEnabled,
      this.roomBrightness,
      this.icon,
      this.roomLightColor,
    );
  }

  @Monitor('roomBrightness', 'roomLightColor', 'roomSleepAfter', 'isNight', 'icon')
  onStrChange(monitor: IMonitor) {
    monitor.dirty.forEach((path: string) => {
      if (path === 'roomBrightness') {
        this.roomItemSendable.brightness = monitor.value(path)?.now as number;
      }
      if (path === 'icon') {
        this.roomItemSendable.icon = monitor.value(path)?.now as string;
      }
      if (path === 'roomLightColor') {
        this.roomItemSendable.roomLightColor = monitor.value(path)?.now as string;
      }
    });
  }

  async setTimer(minutes: number) {
    const currentRoom = this;
    let reason = 'Turn room light off';
    try {
      let token = backgroundTaskManager.requestSuspendDelay(reason, () => {
        const appData = AppStorageV2.connect(AppData, `timer_${currentRoom.id}`);
        if (appData) {
          const timerId: number = appData!.timerId;
          clearTimeout(timerId);
          AppStorageV2.remove(`timer_${currentRoom.id}`);
        }
      });

      console.info(`Suspend delay token: ${token}`);
      const timerId = setTimeout(() => {
        currentRoom.isEnabled = false;
      }, minutes * 1000);

      const appData = new AppData(token.requestId, timerId, minutes);

      AppStorageV2.connect(AppData, `timer_${currentRoom.id}`, () => appData);

      console.info('Task started after 5 minutes in background');

      backgroundTaskManager.cancelSuspendDelay(token.requestId);
    } catch (error) {
      console.error(`Operation requestSuspendDelay failed. code is ${(error as BusinessError).code} message is ${(error as BusinessError).message}`);
    }
  }

  removeTimer() {
    const appData = AppStorageV2.connect(AppData, `timer_${this.id}`, () => new AppData())!;
    const requestId: number = appData.requestId;
    const timerId: number = appData.timerId;
    if (requestId !== -1 && timerId !== -1) {
      try {
        backgroundTaskManager.cancelSuspendDelay(requestId);
      } catch (err) {
        console.error(`[ANS] requestEnableNotification failed, code is ${err.code}, message is ${err.message}`);
      }
      AppStorageV2.remove(`timer_${this.id}`);
    }
  }
}

@Sendable
export class RoomItemSendable implements lang.ISendable {
  id: number;
  name: string;
  isEnabled: boolean;
  brightness: number;
  icon: string;
  roomLightColor: string;

  constructor(
    id: number,
    name: string,
    isEnabled: boolean = false,
    brightness: number = 50,
    icon: string = 'app.media.livingRoomActive',
    roomLightColor: string = '#FFFFFF'
  ) {
    this.id = id;
    this.name = name;
    this.isEnabled = isEnabled;
    this.brightness = brightness;
    this.icon = icon;
    this.roomLightColor = roomLightColor;
  }
}
