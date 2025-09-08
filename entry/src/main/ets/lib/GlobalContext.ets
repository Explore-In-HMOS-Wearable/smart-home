export default class GlobalContext {
  private static instance: GlobalContext;
  private uiContext?: UIContext;

  static getInstance() {
    if (!GlobalContext.instance) {
      GlobalContext.instance = new GlobalContext();
    }
    return GlobalContext.instance;
  }

  public saveUIContext(context: UIContext) {
    this.uiContext = context;
  }

  public getUIContext() {
    return this.uiContext;
  }
}