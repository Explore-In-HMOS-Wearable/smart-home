import { RoomItemModel } from '../viewmodels/RoomItemModel';
import { Action } from '@hadss/state_store';
import RoomListActions from '../store/RoomListActions';
import { roomListStore } from '../store/RoomListStore';

interface Payload {
  id: number;
  value: boolean
}

export function toggleStatus(roomItem: RoomItemModel) {
  const payload: Payload = { id: roomItem.id, value: !roomItem.isEnabled };
  const action: Action = RoomListActions.enableRoomItem.setPayload(payload);
  roomListStore.dispatch(action);
}