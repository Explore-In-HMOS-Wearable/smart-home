import { PromptAction } from '@kit.ArkUI';

@Extend(Button)
function btnStyle() {
  .backgroundColor(Color.Transparent)
  .border({
    color: Color.White,
    style: BorderStyle.Solid,
    width: 1
  })
  .padding(5)
}

@ComponentV2
export struct CustomDialog {
  @Param @Require customDialogComponentId: number = 0;
  context: UIContext = this.getUIContext();
  prompt: PromptAction = this.context.getPromptAction();
  @Param @Require onSelect: (minutes: number) => void = () => {
  }

  onSelectionClick(minutes: number) {
    this.onSelect(minutes);
    this.closeDialog();
  }

  closeDialog() {
    try {
      this.prompt.closeCustomDialog(this.customDialogComponentId)
    } catch (error) {
      console.error(`closeCustomDialog error code is ${error.code}, message is ${error.message}`);
    }
  }

  build() {
    Column() {
      Blank('4vp')
      Row({ space: 20 }) {
        Button({ type: ButtonType.ROUNDED_RECTANGLE }) {
          Text('5m')
            .fontSize(14)
        }
        .btnStyle()
        .onClick(() => this.onSelectionClick(5))

        Button() {
          Text('15m')
            .fontSize(14)
        }
        .btnStyle()
        .onClick(() => this.onSelectionClick(15))

        Button() {
          Text('30m')
            .fontSize(14)
        }
        .btnStyle()
        .onClick(() => this.onSelectionClick(30))
      }
      .justifyContent(FlexAlign.Center)
      .width('100%')

      Blank('4vp')
      Row() {
        Button() {
          Text('Close')
            .fontSize(14)
        }
        .padding(5)
        .onClick(() => this.closeDialog())
      }
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .height('50%')
    .width('100%')
    .padding(5)
  }
}
