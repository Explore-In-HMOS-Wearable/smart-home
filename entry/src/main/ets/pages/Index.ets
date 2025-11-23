import { RoomsListView } from '../views/RoomsListView';
import { notificationManager } from '@kit.NotificationKit';
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { RoomItemPageBuilder } from './RoomItemPage';
import { RoomListStore } from '../store/RoomListStore';
import RoomListActions from '../store/RoomListActions';

@Entry
@Component
struct Index {
  pathStack: NavPathStack = new NavPathStack();

  aboutToAppear() {
    AppStorage.setOrCreate('PathStack', this.pathStack);
    this.getPermission(this.getUIContext().getHostContext() as common.UIAbilityContext)
  }

  @Builder
  pageMap(name: string) {
    NavDestination() {
      if (name === 'RoomItemPage') {
        RoomItemPageBuilder()
      }
    }
    .hideToolBar(true)
    .hideBackButton(true)
  }

  build() {
    Navigation(this.pathStack) {
      RelativeContainer() {
        RoomsListView()
      }
    }
    .navDestination(this.pageMap)
    .hideTitleBar(true)
    .onNavBarStateChange(() => {
      RoomListStore.dispatch(RoomListActions.getRoomList);
    })
  }

  getPermission(context: common.UIAbilityContext) {
    notificationManager.isNotificationEnabled().then((data: boolean) => {
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