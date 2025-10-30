#pragma once

#include "include/cef_app.h"

class SimpleApp : public CefApp, public CefBrowserProcessHandler {
 public:
  SimpleApp();

  virtual CefRefPtr<CefBrowserProcessHandler> GetBrowserProcessHandler()
      override {
    return this;
  }

  virtual void OnRegisterCustomSchemes(
      CefRawPtr<CefSchemeRegistrar> registrar) override;

  virtual void OnBeforeCommandLineProcessing(
      const CefString& process_type,
      CefRefPtr<CefCommandLine> command_line) override;

  virtual void OnContextInitialized() override;

 private:
  IMPLEMENT_REFCOUNTING(SimpleApp);
};
