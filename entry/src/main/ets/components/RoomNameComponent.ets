import { roomListStore } from '../store/RoomListStore';
import { RoomItemModel } from '../viewmodels/RoomItemModel';

@Builder
export function roomNameBuilder() {
  RoomNameComponent();
}

@ComponentV2
export struct RoomNameComponent {
  @Param title: string = 'Brightness';
  @Local roomItem: RoomItemModel = roomListStore.getState().currentRoom;

  build() {
    Text(`${this.roomItem.name} ${this.title}`)
      .maxLines(1)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .ellipsisMode(EllipsisMode.END)
      .textAlign(TextAlign.Center)
      .fontSize($r('app.float.font_sm'))
      .fontWeight(FontWeight.Bold)
      .fontColor(Color.White)
  }
}