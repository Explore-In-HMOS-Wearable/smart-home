import { RoomsListView } from '../views/RoomsListView';

import { notificationManager } from '@kit.NotificationKit';
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct Index {
  aboutToAppear() {
    this.getPermission(this.getUIContext().getHostContext() as common.UIAbilityContext)
  }

  build() {
    RelativeContainer() {
      RoomsListView()
    }
  }

  getPermission(context: common.UIAbilityContext) {
    notificationManager.isNotificationEnabled().then((data: boolean) => {
      console.info('isNotificationEnabled success, data: ' + JSON.stringify(data));
      if (!data) {
        notificationManager.requestEnableNotification(context).then(() => {
          console.info(`[ANS] requestEnableNotification success`);
        }).catch((err: BusinessError) => {
          if (1600004 == err.code) {
            console.error(`[ANS] requestEnableNotification refused, code is ${err.code}, message is ${err.message}`);
          } else {
            console.error(`[ANS] requestEnableNotification failed, code is ${err.code}, message is ${err.message}`);
          }
        });
      }
    }).catch((err: BusinessError) => {
      console.error(`isNotificationEnabled fail, code is ${err.code}, message is ${err.message}`);
    });
  }
}