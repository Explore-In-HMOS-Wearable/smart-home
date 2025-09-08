import { Action } from '@hadss/state_store';
import { ArcDirection, ArcDotIndicator, ArcSwiper, ComponentContent } from '@kit.ArkUI';
import RoomListActions from '../store/RoomListActions';
import { RoomListStore } from '../store/RoomListStore';
import { RoomStoreModel } from '../viewmodels/RoomStoreModel';
import { roomNameBuilder, RoomNameComponent } from './RoomNameComponent';

interface BackgroundColor {
  name: string;
  color: Color;
}

class ColorDataSource implements IDataSource {
  private list: BackgroundColor[] = [];

  constructor(list: BackgroundColor[]) {
    this.list = list;
  }

  totalCount(): number {
    return this.list.length;
  }

  getData(index: number): BackgroundColor {
    return this.list[index];
  }

  getIndexOf(name: string): number {
    return this.list.findIndex((bgColor) => bgColor.name === name);
  }

  registerDataChangeListener(listener: DataChangeListener): void {
  }

  unregisterDataChangeListener() {
  }
}

@ComponentV2
export default struct RoomColorComponent {
  @Local viewModel: RoomStoreModel = RoomListStore.getState();
  context: UIContext = this.getUIContext();
  header: ComponentContent<Object> = new ComponentContent(this.context, wrapBuilder(roomNameBuilder));
  @Local backgroundColors: BackgroundColor[] = [
    {
      'name': 'Green',
      'color': Color.Green,
    },
    {
      'name': 'Blue',
      'color': Color.Blue,
    },
    {
      'name': 'Yellow',
      'color': Color.Yellow,
    },
    {
      'name': 'Pink',
      'color': Color.Pink,
    },
    {
      'name': 'White',
      'color': Color.White,
    },
    {
      'name': 'Gray',
      'color': Color.Gray,
    },
    {
      'name': 'Orange',
      'color': Color.Orange,
    },
    {
      'name': 'Transparent',
      'color': Color.Transparent,
    },
  ];
  private arcDotIndicator: ArcDotIndicator = new ArcDotIndicator();
  private data: ColorDataSource = new ColorDataSource([]);

  aboutToAppear(): void {
    let list: Color[] = [];
    for (let i = 1; i <= 6; i++) {
      list.push(i);
    }
    this.data = new ColorDataSource(this.backgroundColors);
  }

  build() {
    Column() {
      ArcSwiper() {
        LazyForEach(this.data, (backgroundColor: BackgroundColor, index: number) => {
          Column() {
            RoomNameComponent({ title: 'Colors' })
              .margin({ bottom: '16px' })
            Text(backgroundColor.name)
              .width(120)
              .height(120)
              .fontColor(backgroundColor.name === 'White' ? Color.Black : Color.White)
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .backgroundColor(backgroundColor.color)
              .textAlign(TextAlign.Center)
              .borderRadius('50%')
              .borderColor(Color.White)
              .borderWidth(1)
          }
          .justifyContent(FlexAlign.Center)
          .size({ width: '100%', height: '100%' })
          .alignItems(HorizontalAlign.Center)
          .alignRules({
            middle: { anchor: '__container__', align: HorizontalAlign.Center },
            center: { anchor: '__container__', align: VerticalAlign.Center }
          })
        })
      }
      .index(this.data.getIndexOf(this.viewModel.currentRoom.roomLightColor))
      .effectMode(EdgeEffect.None)
      .backgroundColor(Color.Transparent)
      .vertical(false)
      .indicator(
        this.arcDotIndicator
          .arcDirection(ArcDirection.SIX_CLOCK_DIRECTION)
          .selectedItemColor($r('app.color.bg_green'))
          .backgroundColor(Color.Transparent)
      )
      .digitalCrownSensitivity(CrownSensitivity.MEDIUM)
      .onChange((index: number) => {
        const colorName: string = this.data.getData(index).name;
        const action: Action = RoomListActions.updateRoomItem.setPayload({ lightColor: colorName });
        RoomListStore.dispatch(action)
      })
    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height('100%')
  }
}