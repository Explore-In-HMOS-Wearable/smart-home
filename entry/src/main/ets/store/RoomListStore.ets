import { StateStore, Store } from '@hadss/state_store';
import { RoomStoreModel } from '../viewmodels/RoomStoreModel';
import { roomListReducer } from './RoomListReducer';

export const ROOM_LIST_STORE_ID = 'roomListStore';

export const RoomListStore: Store<RoomStoreModel> =
  StateStore.createStore(ROOM_LIST_STORE_ID, new RoomStoreModel(), roomListReducer, []);

