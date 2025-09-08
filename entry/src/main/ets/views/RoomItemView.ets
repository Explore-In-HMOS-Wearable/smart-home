import {
  ArcDirection,
  ArcDotIndicator,
  ArcSwiper,
  ArcSwiperController,
  CircleShape,
  ComponentContent,
  Router
} from '@kit.ArkUI';
import RoomBrightnessComponent from '../components/RoomBrightnessComponent';
import RoomColorComponent from '../components/RoomColorComponent';
import { RoomListStore } from '../store/RoomListStore';
import { RoomItemModel } from '../viewmodels/RoomItemModel';
import { headerSheetBuilder } from '../components/HeaderSheetBuilder';
import { RoomItemInfo } from '../components/RoomItemInfo';

@Component
export struct RoomItemView {
  roomItem: RoomItemModel = RoomListStore.getState().currentRoom;
  context: UIContext = this.getUIContext();
  router: Router = this.context.getRouter();
  header: ComponentContent<Object> = new ComponentContent(this.context, wrapBuilder(headerSheetBuilder));
  private wearableSwiperController: ArcSwiperController = new ArcSwiperController();
  private arcDotIndicator: ArcDotIndicator = new ArcDotIndicator();

  build() {
    Column() {
      Row() {
        ArcSwiper(this.wearableSwiperController) {
          RoomItemInfo()
          RoomBrightnessComponent()
          RoomColorComponent()
        }
        .clipShape(new CircleShape({ width: 233, height: 233 }))
        .effectMode(EdgeEffect.None)
        .backgroundColor(Color.Black)
        .index(0)
        .duration(400)
        .vertical(true)
        .indicator(
          this.arcDotIndicator
            .arcDirection(ArcDirection.THREE_CLOCK_DIRECTION)
            .selectedItemColor($r('app.color.bg_green'))
            .itemColor('#E0E0E0')
            .backgroundColor(Color.Black)
            .maskColor(new LinearGradient([{
              color: Color.Transparent,
              offset: 0,
            }]))
        )
        .disableSwipe(false)
        .digitalCrownSensitivity(CrownSensitivity.MEDIUM)
        .onChange((index: number) => {
          console.info('onChange:' + index.toString());
        })
      }
      .height('100%')
    }
    .width('100%')
  }

  pageTransition() {
    PageTransitionEnter({ duration: 1000 })
      .slide(SlideEffect.Left)
    PageTransitionExit({ duration: 1200 })
      .translate({ x: 100.0, y: 100.0 })
      .opacity(0)
  }
}