import { toggleStatus } from '../lib/Utils';
import { RoomListStore } from '../store/RoomListStore';
import { RoomItemModel } from '../viewmodels/RoomItemModel';
import { Icon } from './IconContainer';
import { TimerComponent } from './TimerComponent';

@ComponentV2
export struct RoomItemInfo {
  @Local room: RoomItemModel = RoomListStore.getState().currentRoom;

  build() {
    RelativeContainer() {
      Column() {
        Blank().layoutWeight(1)
        Row() {
          Text(this.room.name)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .ellipsisMode(EllipsisMode.END)
            .textAlign(TextAlign.Center)
            .fontColor(this.room.isEnabled ? Color.Black : Color.White)
            .fontSize($r('app.float.font_lg'))
            .fontWeight(FontWeight.Bold)
        }

        Row() {
          Icon({ iconSrc: $r(this.room.icon), iconWidth: 50, iconHeight: 50 })
            .padding($r('app.float.vp_16'))
          Column() {
            if (this.room.isEnabled) {
              Icon({ iconSrc: $r('app.media.lightBulbOn') })
            } else {
              Icon({ iconSrc: $r('app.media.lightBulbOff') })
            }
            Text('Light')
              .fontSize($r('app.float.font_sm'))
              .textAlign(TextAlign.Center)
              .fontColor(this.room.isEnabled ? Color.Black : Color.White)
          }
          .margin({ left: $r('app.float.vp_8') })
          .onClick(() => {
            toggleStatus(this.room);
          })
        }

        Blank().layoutWeight(1)
        Row() {
          TimerComponent()
        }
      }
      .backgroundColor(this.room.isEnabled ? Color.White : Color.Black)
      .justifyContent(FlexAlign.Center)
      .height('100%')
      .width('100%')
    }
  }
}