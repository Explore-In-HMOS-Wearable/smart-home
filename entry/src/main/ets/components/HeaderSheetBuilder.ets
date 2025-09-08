@Builder
export function headerSheetBuilder() {
  Column() {
    Text($r('app.string.EntryAbility_label'))
      .fontSize($r('app.float.font_sm'))
      .fontWeight(FontWeight.Bold)
      .fontColor(Color.White)
  }
  .justifyContent(FlexAlign.Center)
  .margin({ top: $r('app.float.vp_16'), bottom: 0 })
}