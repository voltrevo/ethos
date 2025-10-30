// simple_app.cc
#include "include/cef_app.h"
#include "include/cef_browser.h"
#include "include/views/cef_browser_view.h"
#include "include/views/cef_window.h"
#include "include/wrapper/cef_helpers.h"

namespace {
std::string GetStartURL() {
  const char* s = std::getenv("START_URL");
  return s && *s ? std::string(s) : "https://example.com";
}
}

class BrowserWindowDelegate : public CefWindowDelegate {
 public:
  explicit BrowserWindowDelegate(CefRefPtr<CefBrowserView> view) : view_(view) {}

  void OnWindowCreated(CefRefPtr<CefWindow> window) override {
    window->AddChildView(view_);
    window->CenterWindow(CefSize(1024, 700));   // pick a size
    // “Plain top bar” (regular OS title bar, no menus/toolbars from us):
    // nothing else needed.

    // If you want **frameless** instead, uncomment these on macOS:
    // window->SetTitlebarHeight(0);
    // window->SetWindowButtonVisibility(false);
  }

  bool CanClose(CefRefPtr<CefWindow> window) override {
    return view_->GetBrowser()->GetHost()->TryCloseBrowser();
  }

 private:
  CefRefPtr<CefBrowserView> view_;
  IMPLEMENT_REFCOUNTING(BrowserWindowDelegate);
};

void SimpleApp::OnContextInitialized() {
  CEF_REQUIRE_UI_THREAD();

  CefBrowserSettings browser_settings;
  auto browser_view = CefBrowserView::CreateBrowserView(
      this, GetStartURL(), browser_settings, /*client=*/nullptr,
      /*request_context=*/nullptr, /*extra_info=*/nullptr);

  CefWindow::CreateTopLevelWindow(new BrowserWindowDelegate(browser_view));
}
