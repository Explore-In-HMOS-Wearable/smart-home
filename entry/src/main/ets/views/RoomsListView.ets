import {
  ArcList, ArcListItem, ComponentContent, LengthMetrics
} from '@kit.ArkUI';
import RoomListActions from '../store/RoomListActions';
import { RoomListStore } from '../store/RoomListStore';
import { RoomStoreModel } from '../viewmodels/RoomStoreModel';
import { RoomItemModel } from '../viewmodels/RoomItemModel';
import { addSheetBuilder } from '../components/AddSheetBuilder';
import { headerSheetBuilder } from '../components/HeaderSheetBuilder';
import { Icon } from '../components/IconContainer';
import RoomListItemComponent from '../components/RoomListItemComponent';

@ComponentV2
export struct RoomsListView {
  @Local viewModel: RoomStoreModel = RoomListStore.getState();
  context: UIContext = this.getUIContext();
  header: ComponentContent<Object> = new ComponentContent(this.context, wrapBuilder(headerSheetBuilder));

  @Computed
  get roomListNum(): number {
    return this.viewModel.roomList.length;
  }

  aboutToAppear() {
    RoomListStore.dispatch(RoomListActions.getRoomList);
  }

  build() {
    Column() {
      ArcList({ initialIndex: 0, header: this.header }) {
        ArcListItem() {
          Column() {
            Row() {
              Column() {
                Icon({ iconSrc: $r('app.media.plusIcon') })
                Text($r('app.string.add_room'))
                  .fontSize('14px')
                  .fontColor(Color.White)
              }
              .onClick(async () => {
                RoomListStore.dispatch(RoomListActions.showSheet);
              })

              Blank('16px')
              Column() {
                Icon({
                  iconSrc: this.viewModel.isAllEnabled ? $r('app.media.lightBulbOff') : $r('app.media.lightBulbOn'),
                })
                Text($r('app.string.light_all'))
                  .fontSize('14px')
                  .fontColor(Color.White)
              }
              .onClick(async () => {
                if (this.viewModel.isAllEnabled) {
                  RoomListStore.dispatch(RoomListActions.disableAll)
                } else {
                  RoomListStore.dispatch(RoomListActions.enableAll)
                }
              })
            }

            Blank('16px')
            Text(`Total of ${this.roomListNum} room${this.roomListNum === 1 ? '' : 's'}`)
              .fontSize($r('app.float.font_sm'))
          }
          .width('100%')
          .margin({ bottom: 10 })
        }


        ForEach(this.viewModel.roomList, (roomItem: RoomItemModel) => {
          RoomListItemComponent({ roomItem: roomItem })

        }, (item: RoomItemModel) => item.id.toString())
      }
      .space(LengthMetrics.px(4))
      .borderRadius($r('app.float.watch_size'))
      .focusable(true)
      .focusOnTouch(true)
      .defaultFocus(true)
      .scrollBar(BarState.Off)
    }
    .justifyContent(FlexAlign.Start)
    .height('100%')
    .width('100%')
    .bindSheet(
      this.viewModel.isShow, addSheetBuilder, {
      height: '70%',
      showClose: true,
      backgroundColor: $r('app.color.page_background'),
      keyboardAvoidMode: SheetKeyboardAvoidMode.RESIZE_ONLY,
      onWillDismiss: () => {
        RoomListStore.dispatch(RoomListActions.hideSheet);
      }
    })
  }
}