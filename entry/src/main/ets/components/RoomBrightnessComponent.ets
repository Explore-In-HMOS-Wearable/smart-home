import { RoomItemModel } from '../viewmodels/RoomItemModel';
import { RoomListStore } from '../store/RoomListStore';
import RoomListActions from '../store/RoomListActions';
import { RoomNameComponent } from './RoomNameComponent';

@Component
export default struct RoomBrightnessComponent {
  roomItem: RoomItemModel = RoomListStore.getState().currentRoom;
  context: UIContext = this.getUIContext();

  build() {
    Column() {
      RoomNameComponent()
      Slider({
        value: this.roomItem.roomBrightness,
        min: 0,
        max: 100,
        style: SliderStyle.InSet
      })
        .blockColor('#388E3C')
        .trackColor('#E0E0E0')
        .selectedColor('#4CAF50')
        .showTips(true)
        .onChange((value: number, mode: SliderChangeMode) => {
          RoomListStore.dispatch(RoomListActions.updateRoomItem.setPayload({ brightness: value }))
        })
        .onDigitalCrown((event: CrownEvent) => {
          event.stopPropagation();
        })
        .width('80%')
      Text(this.roomItem.roomBrightness.toFixed(0)).fontSize(12)
    }
    .justifyContent(FlexAlign.Center)
    .height('100%')
    .width('100%')
  }
}

