import RoomListActions from '../store/RoomListActions';
import { roomListStore } from '../store/RoomListStore';
import { Icon } from './IconContainer';
import { RoomStoreModel } from '../viewmodels/RoomStoreModel';

@Builder
export function addSheetBuilder() {
  AddSheetComponent();
}

@ComponentV2
struct AddSheetComponent {
  viewModel: RoomStoreModel = roomListStore.getState();

  build() {
    Column() {
      Blank().layoutWeight(1)
      Column({ space: 8 }) {
        TextInput({ text: this.viewModel.addRoomNameInputValue, placeholder: $r('app.string.add_room') })
          .backgroundColor($r('app.color.color_white'))
          .enableKeyboardOnFocus(true)
          .fontColor(Color.Black)
          .placeholderColor(Color.Gray)
          .margin({ top: $r('app.float.vp_8') })
          .onChange((value) => {
            roomListStore.dispatch(RoomListActions.changeTextInput.setPayload(value));
          });
        Row() {
          Icon({
            iconSrc: this.viewModel.addRoomIcon === 'app.media.livingRoomActive' ?
              $r('app.media.livingRoomActive') : $r('app.media.livingRoom')
          })
            .onClick(() => {
              roomListStore.dispatch(RoomListActions.changeIconInput.setPayload('app.media.livingRoomActive'));
            })
          Icon({
            iconSrc: this.viewModel.addRoomIcon === 'app.media.bathroomActive' ?
              $r('app.media.bathroomActive') : $r('app.media.bathroom')
          })
            .onClick(() => {
              roomListStore.dispatch(RoomListActions.changeIconInput.setPayload('app.media.bathroomActive'));
            })
          Icon({
            iconSrc: this.viewModel.addRoomIcon === 'app.media.washingRoomActive' ?
              $r('app.media.washingRoomActive') : $r('app.media.washingRoom')
          })
            .onClick(() => {
              roomListStore.dispatch(RoomListActions.changeIconInput.setPayload('app.media.washingRoomActive'));
            })
          Icon({
            iconSrc: this.viewModel.addRoomIcon === 'app.media.bedroomActive' ?
              $r('app.media.bedroomActive') : $r('app.media.bedroom')
          })
            .onClick(() => {
              roomListStore.dispatch(RoomListActions.changeIconInput.setPayload('app.media.bedroomActive'));
            })

        }
      }
      .padding({ left: $r('app.float.vp_16'), right: $r('app.float.vp_16') })

      Blank().layoutWeight(1)
      Button($r('app.string.add_room'), { type: ButtonType.Capsule })
        .fontSize($r('app.float.font_sm'))
        .onClick(() => {
          roomListStore.dispatch(RoomListActions.addRoomList);
        })
      Blank().layoutWeight(1)
    }
    .backgroundColor($r('app.color.bg_green'))
  }
}
