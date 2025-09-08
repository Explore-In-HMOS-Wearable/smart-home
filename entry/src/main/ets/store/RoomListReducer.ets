import { Action, Reducer } from '@hadss/state_store';
import { BusinessError } from '@kit.BasicServicesKit';
import { RoomItemModel } from '../viewmodels/RoomItemModel';
import { RoomStoreModel } from '../viewmodels/RoomStoreModel';
import RoomListActions from './RoomListActions';
import RdbUtil from '../lib/RdbUtil';
import GlobalContext from '../lib/GlobalContext';
import promptAction from '@ohos.promptAction';

let uiContext: UIContext | undefined

export const roomListReducer: Reducer<RoomStoreModel> = (state: RoomStoreModel, action: Action) => {
  let GlobalContent = GlobalContext.getInstance();
  uiContext = GlobalContent.getUIContext()
  switch (action.type) {
    case RoomListActions.getRoomItem.type:
      const room = state.roomList.find(item => item.id === action.payload.id);
      if (room) {
        state.currentRoom = room;
      }
      break;
    case RoomListActions.getRoomList.type:
      return async () => {
        state.roomList = (await RdbUtil.getInstance(uiContext?.getHostContext()!)).query();
      };
    case RoomListActions.addRoomList.type:
      if (state.addRoomNameInputValue === '') {
        try {
          uiContext!.getPromptAction().showToast({ message: $r('app.string.empty') });
        } catch (err) {
          console.error(`Error: code is ${err.code}, message is ${err.message}`);
        }
        return null;
      }
      const newRoom = new RoomItemModel(state.addRoomNameInputValue, state.addRoomIcon);

      state.roomList.push(newRoom);

      state.addRoomNameInputValue = '';
      state.addRoomIcon = 'app.media.livingRoomActive';
      state.isShow = false;

      RdbUtil.getInstance(uiContext?.getHostContext()!).then((rdb) => {
        rdb.insert(newRoom.roomItemSendable);
      })

      break;
    case RoomListActions.deleteRoomItem.type:
      uiContext!
        .getPromptAction()
        .showDialog({
          message: $r('app.string.delete_current_room'),
          buttons: [
            {
              text: $r('app.string.dialog_cancel'),
              color: $r('app.color.text_blue')
            },
            {
              text: $r('app.string.dialog_delete'),
              color: $r('app.color.text_blue')
            }
          ]
        }).catch((err: BusinessError) => {
        console.error(`Error: code is ${err.code}, message is ${err.message}`);
      })
        .then((res: void | promptAction.ShowDialogSuccessResponse) => {
          if (res && res.index === 1) {
            let index: number | undefined;
            state.roomList.find((item, _index) => {
              index = _index;
              return item.id === action.payload;
            });
            if (index !== undefined) {
              const room = state.roomList[index];
              state.roomList.splice(index, 1);
              RdbUtil.getInstance(uiContext?.getHostContext()!).then((rdb) => {
                rdb.delete(room.id);
              })
            }
          }
        });
      break;
    case RoomListActions.updateRoomItem.type:
      if (action.payload.brightness) {
        state.currentRoom.roomBrightness = action.payload.brightness as number;
      }
      if (action.payload.lightColor) {
        state.currentRoom.roomLightColor = action.payload.lightColor as string;
      }
      state.roomList = state.roomList.map((room) => {
        if (room.id === state.currentRoom.id) {
          return state.currentRoom;
        }
        return room;
      });
      RdbUtil.getInstance(uiContext?.getHostContext()!).then((rdb) => {
        rdb.update(state.currentRoom.roomItemSendable);
      })

      break;
    case RoomListActions.enableRoomItem.type:
      const roomItem = state.roomList.find(item => item.id === action.payload.id);
      if (roomItem) {
        roomItem.isEnabled = action.payload.value;
        roomItem.roomItemSendable.isEnabled = action.payload.value;
      }
      break;
    case RoomListActions.disableRoomItem.type:
      const item = state.roomList.find(item => item.id === action.payload);
      if (item) {
        item.isEnabled = false;
        item.roomItemSendable.isEnabled = false;
      }
      break;
    case RoomListActions.changeTextInput.type:
      state.addRoomNameInputValue = action.payload;
      break;
    case RoomListActions.changeIconInput.type:
      state.addRoomIcon = action.payload;
      break;
    case RoomListActions.clearRoomList.type:
      uiContext!
        .getPromptAction()
        .showDialog({
          message: $r('app.string.delete_rooms', state.roomList.filter(item => item.isEnabled).length),
          buttons: [
            {
              text: $r('app.string.dialog_cancel'),
              color: $r('app.color.text_blue')
            },
            {
              text: $r('app.string.dialog_delete'),
              color: $r('app.color.text_blue')
            }
          ]
        }).catch((err: BusinessError) => {
        console.error(`Error: code is ${err.code}, message is ${err.message}`);
      })
        .then((res: void | promptAction.ShowDialogSuccessResponse) => {
          if (res && res.index === 1) {
            for (let i = state.roomList.length - 1; i >= 0; i--) {
              if (state.roomList[i].isEnabled) {
                state.roomList.splice(i, 1);
              }
            }
          }
        });
      break;
    case RoomListActions.enableAll.type:
      state.isAllEnabled = true;
      state.roomList = state.roomList.map((room) => {
        room.isEnabled = true;
        return room;
      });
      break;
    case RoomListActions.disableAll.type:
      state.isAllEnabled = false;
      state.roomList = state.roomList.map((room) => {
        room.isEnabled = false;
        return room;
      });
      break;
    case RoomListActions.showSheet.type:
      state.isShow = true;
      break;
    case RoomListActions.hideSheet.type:
      state.isShow = false;
      state.addRoomNameInputValue = '';
      break;
  }
  return null;
};

