import { image } from '@kit.ImageKit';

@ComponentV2
export struct Icon {
  @Param @Require iconSrc: image.PixelMap | ResourceStr | DrawableDescriptor;
  @Param iconWidth: number = 24;
  @Param iconHeight: number = 24;

  build() {
    Row() {
      Image(this.iconSrc)
        .width(this.iconWidth)
        .height(this.iconHeight)
    }
    .width(this.iconWidth)
    .height(this.iconHeight)
    .borderRadius('50%')
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Center)
    .margin({ bottom: $r('app.float.vp_8') })
  }
}