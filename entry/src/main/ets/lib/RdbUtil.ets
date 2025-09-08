import { relationalStore } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { RoomItemModel, RoomItemSendable } from '../viewmodels/RoomItemModel';
import { hilog } from '@kit.PerformanceAnalysisKit';

export default class RdbUtil {
  private static readonly STORE_CONFIG: relationalStore.StoreConfig = {
    name: 'SmartHomeSample.db',
    securityLevel: relationalStore.SecurityLevel.S3
  };
  private tableName: string = 'RoomList';
  private store: relationalStore.RdbStore | null = null;

  public static async getInstance(context: Context): Promise<RdbUtil> {
    let rdb = new RdbUtil();
    try {
      rdb.store = await relationalStore.getRdbStore(context, RdbUtil.STORE_CONFIG);
      hilog.info(0x0000, 'RDB', 'Succeeded in getting RdbStore.');
    } catch (err) {
      throw Error(`Failed to get RdbStore. Code:${err.code}, message:${err.message}`);
    }
    return rdb;
  }

  public initRdb() {
    const SQL_CREATE_TABLE =
      'CREATE TABLE IF NOT EXISTS RoomList ' +
        '(id int NOT NULL PRIMARY KEY, ' +
        'name text NOT NULL, ' +
        'isEnabled bool NULL DEFAULT false, ' +
        'brightness int NOT null DEFAULT 50,' +
        'lightColor text NOT null,' +
        'icon text NOT NULL)';
    this.store?.executeSql(SQL_CREATE_TABLE);
  }

  public getAllIds(): number[] {
    const SQL_QUERY_ALL = 'SELECT * FROM RoomList';
    let ids: number[] = [];
    let resultSet: relationalStore.ResultSet | undefined = this.store?.querySqlSync(SQL_QUERY_ALL);
    if (resultSet) {
      while (resultSet.goToNextRow()) {
        const id = resultSet.getLong(resultSet.getColumnIndex('id'));
        ids.push(id);
      }
      resultSet.close();
    }
    return ids;
  }

  public query(): RoomItemModel[] {
    const SQL_QUERY_ALL = 'SELECT * FROM RoomList';
    let todoList: RoomItemModel[] = [];
    let resultSet: relationalStore.ResultSet | undefined = this.store?.querySqlSync(SQL_QUERY_ALL);
    if (resultSet) {
      while (resultSet.goToNextRow()) {
        const id = resultSet.getLong(resultSet.getColumnIndex('id'));
        const name = resultSet.getString(resultSet.getColumnIndex('name'));
        const isEnabled = resultSet.getLong(resultSet.getColumnIndex('isEnabled'));
        const brightness = resultSet.getLong(resultSet.getColumnIndex('brightness'));
        const icon = resultSet.getString(resultSet.getColumnIndex('icon'));
        const lightColor = resultSet.getString(resultSet.getColumnIndex('lightColor'));

        const todoItem = new RoomItemModel(name, icon, !!isEnabled, id, brightness, lightColor);
        todoList.push(todoItem);
      }
      resultSet.close();
    }
    return todoList;
  }

  public insert(data: RoomItemSendable) {
    const valueBucket: relationalStore.ValuesBucket = {
      'id': data.id,
      'name': data.name,
      'isEnabled': data.isEnabled ? 1 : 0,
      'brightness': data.brightness ?? 50,
      'icon': data.icon,
      'lightColor': data.roomLightColor,
    };
    this.store?.insert('RoomList', valueBucket, (err: BusinessError, rowId: number) => {
      if (err) {
        hilog.error(0x0000, 'RDB', `Failed to insert data. Code:${err.code}, message:${err.message}`);
        return;
      }
      hilog.info(0x0000, 'RDB', `Succeeded in inserting data. rowId:${rowId}`);
    });
  }

  public update(data: RoomItemSendable) {
    let predicates = new relationalStore.RdbPredicates(this.tableName);
    predicates.equalTo('id', data.id);
    const valueBucket: relationalStore.ValuesBucket = {
      'id': data.id,
      'name': data.name,
      'isEnabled': data.isEnabled ? 1 : 0,
      'brightness': data.brightness ?? 50,
      'lightColor': data.roomLightColor,
    };
    this.store?.update(valueBucket, predicates, (err: BusinessError, rows: number) => {
      if (err) {
        hilog.error(0x0000, 'RDB', `Failed to update data. Code:${err.code}, message:${err.message}`);
        return;
      }
      hilog.info(0x0000, 'RDB', `Update rows: ${rows}`);
    });
  }

  public delete(data: number) {
    let predicates = new relationalStore.RdbPredicates(this.tableName);
    predicates.equalTo('id', data);
    this.store?.delete(predicates, (err: BusinessError, rows: number) => {
      if (err) {
        hilog.error(0x0000, 'RDB', `Failed to delete data. Code:${err.code}, message:${err.message}`);
        return;
      }
      hilog.info(0x0000, 'RDB', `Delete rows: ${rows}`);
    });
  }
};