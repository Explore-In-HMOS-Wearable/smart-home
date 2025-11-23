import {
  AppStorageV2,
  ArcButton,
  ArcButtonOptions,
  ArcButtonStyleMode,
  ColorMetrics,
  LengthMetrics,
  LengthUnit
} from '@kit.ArkUI';
import { RoomStoreModel } from '../viewmodels/RoomStoreModel';
import { RoomListStore } from '../store/RoomListStore';
import { RoomItemModel } from '../viewmodels/RoomItemModel';
import { toggleStatus } from '../lib/Utils';
import { AppData } from '../viewmodels/AppData';
import { CustomDialog } from './CustomDialog';
import { BusinessError } from '@kit.BasicServicesKit';

@ComponentV2
export struct TimerComponent {
  @Local bottomOptions: ArcButtonOptions = new ArcButtonOptions({});
  viewModel: RoomStoreModel = RoomListStore.getState();
  currentRoom: RoomItemModel = this.viewModel.currentRoom
  context: UIContext = this.getUIContext();
  @Local appData: AppData = AppStorageV2.connect(AppData, `timer_${this.currentRoom.id}`, () => new AppData())!;
  @Local minutes: number = this.appData?.timerTime ?? 0;
  @Local customDialogComponentId: number = 0;

  @Builder
  customDialogBuilder() {
    CustomDialog({
      customDialogComponentId: this.customDialogComponentId,
      onSelect: (minutes: number) => {
        this.minutes = minutes;
        this.onTimerClick();
      },
    })
  }

  onDialogHandler() {
    this.context.getPromptAction()
      .openCustomDialog({
        builder: () => {
          this.customDialogBuilder();
        },
        onWillDismiss: (dismissDialogAction: DismissDialogAction) => {
          console.info(`reason ${JSON.stringify(dismissDialogAction.reason)}`)
          if (dismissDialogAction.reason == DismissReason.PRESS_BACK) {
            dismissDialogAction.dismiss()
          }
          if (dismissDialogAction.reason == DismissReason.TOUCH_OUTSIDE) {
            dismissDialogAction.dismiss()
          }
        }
      })
      .then((dialogId: number) => {
        this.customDialogComponentId = dialogId
      })
      .catch((error: BusinessError) => {
        console.error(`openCustomDialog error code is ${error.code}, message is ${error.message}`)
      })
  }

  aboutToAppear() {
    try {
      this.bottomOptions = new ArcButtonOptions({
        label: this.appData.timerId != -1 ? `${this.appData.timerTime} minutes` : 'Set Timer',
        styleMode: ArcButtonStyleMode.EMPHASIZED_LIGHT,
        fontSize: new LengthMetrics(15, LengthUnit.FP),
        shadowEnabled: true,
        backgroundColor: ColorMetrics.resourceColor($r('app.color.bg_green')),
        onClick: () => this.onDialogHandler(),
      })
    } catch (err) {
      console.error(`[ANS] requestEnableNotification failed, code is ${err.code}, message is ${err.message}`);
    }
  }

  startTimer() {
    this.viewModel.currentRoom.setTimer(this.minutes);
  }

  cancelTimer() {
    this.viewModel.currentRoom.removeTimer();
  }

  onTimerClick() {
    if (this.appData.timerId != -1) {
      this.cancelTimer();
    }
    if (!this.currentRoom.isEnabled) {
      toggleStatus(this.currentRoom);
    }

    this.startTimer();
  }

  build() {
    Column() {
      ArcButton({ options: this.bottomOptions })
    }
  }
}