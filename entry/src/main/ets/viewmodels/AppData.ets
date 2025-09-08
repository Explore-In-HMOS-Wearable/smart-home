@ObservedV2
export class AppData {
  @Trace requestId: number = -1;
  @Trace timerId: number = -1;
  @Trace timerTime: number = -1;

  constructor(requestId?: number, timerId?: number, timerTime?: number) {
    this.requestId = requestId ?? -1;
    this.timerId = timerId ?? -1;
    this.timerTime = timerTime ?? -1;
  }
}