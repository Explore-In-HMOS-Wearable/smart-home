import { ArcListItem, Router } from '@kit.ArkUI';
import { RoomToggleComponentBuilder } from './RoomToggleComponentBuilder';
import { RoomItemModel } from '../viewmodels/RoomItemModel';
import { RoomListStore } from '../store/RoomListStore';
import RoomListActions from '../store/RoomListActions';
import { Icon } from './IconContainer';
import { Action } from '@hadss/state_store';

@ComponentV2
export default struct RoomListItemComponent {
  @Param @Require roomItem: RoomItemModel;
  context: UIContext = this.getUIContext();
  router: Router = this.context.getRouter();

  @Builder
  itemEnd() {
    Row() {
      SymbolGlyph($r('sys.symbol.trash_circle'))
        .fontColor([$r('app.color.bg_red')])
        .fontSize($r('app.float.vp_16'))
    }
    .padding('4vp')
    .onClick(() => {
      const action: Action = RoomListActions.deleteRoomItem.setPayload(this.roomItem.id)
      RoomListStore.dispatch(action);
    })
  }

  build() {
    ArcListItem() {
      Button({ type: ButtonType.Capsule }) {
        Row() {
          Icon({ iconSrc: $r(this.roomItem.icon) })
          Text(this.roomItem.name)
            .maxLines(1)
            .width('200px')
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .ellipsisMode(EllipsisMode.END)
          RoomToggleComponentBuilder(this.roomItem)
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width('75%')
      }
      .fontSize($r('app.float.font_lg'))
      .width($r('app.float.list_size'))
      .height('100px')
      .focusable(false)
      .focusOnTouch(false)
      .backgroundColor($r('app.color.bg_green'))
      .onClick(() => {
        RoomListStore.dispatch(RoomListActions.getRoomItem.setPayload({ id: this.roomItem.id }))
        this.router.pushUrl({ url: 'pages/RoomItemPage' });
      })
    }
    .transition({ type: TransitionType.Delete, opacity: 0 })
    .swipeAction({
      end: {
        builder: () => {
          this.itemEnd()
        }
      }
    })
    .align(Alignment.Center)
  }
}

