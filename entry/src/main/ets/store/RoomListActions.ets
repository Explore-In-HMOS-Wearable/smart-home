import { Action, StateStore } from '@hadss/state_store';

export default class RoomListActions {
  static getRoomList: Action = StateStore.createAction('getRoomList');
  static addRoomList: Action = StateStore.createAction('addRoomList');
  static disableAll: Action = StateStore.createAction('disableAll');
  static enableAll: Action = StateStore.createAction('enableAll');
  static getRoomItem: Action = StateStore.createAction('getRoomItem');
  static deleteRoomItem: Action = StateStore.createAction('deleteRoomItem');
  static updateRoomItem: Action = StateStore.createAction('updateRoomItem');
  static enableRoomItem: Action = StateStore.createAction('enableRoomItem');
  static disableRoomItem: Action = StateStore.createAction('disableRoomItem');
  static clearRoomList: Action = StateStore.createAction('clearRoomList');
  static changeTextInput: Action = StateStore.createAction('changeTextInput');
  static changeIconInput: Action = StateStore.createAction('changeIconInput');
  static showSheet: Action = StateStore.createAction('showSheet');
  static hideSheet: Action = StateStore.createAction('hideSheet');
}