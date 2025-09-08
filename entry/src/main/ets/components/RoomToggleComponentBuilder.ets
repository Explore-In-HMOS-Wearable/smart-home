import { toggleStatus } from '../lib/Utils';
import { RoomItemModel } from '../viewmodels/RoomItemModel';
import { Icon } from './IconContainer';

@Builder
export function RoomToggleComponentBuilder(roomItem: RoomItemModel) {
  Icon({
    iconSrc: roomItem.isEnabled ? $r('app.media.lightBulbOn') : $r('app.media.lightBulbOff'),
    iconWidth: 18,
    iconHeight: 18,
  })
    .onClick(() => {
      toggleStatus(roomItem);
    })
}
