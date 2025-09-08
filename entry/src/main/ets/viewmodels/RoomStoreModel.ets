import { RoomItemModel } from './RoomItemModel';

@ObservedV2
export class RoomStoreModel {
  @Trace roomList: RoomItemModel[] = [];
  @Trace isShow: boolean = false;
  @Trace currentRoom: RoomItemModel = new RoomItemModel('');
  @Trace isAllEnabled: boolean = false;
  @Trace addRoomIcon: string = 'app.media.livingRoomActive';
  addRoomNameInputValue: string = '';
}