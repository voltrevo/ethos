#include "tests/cefsimple/simple_app.h"
#include "tests/cefsimple/simple_handler.h"

#include "include/cef_browser.h"
#include "include/wrapper/cef_helpers.h"

// Views API:
#include "include/views/cef_browser_view.h"
#include "include/views/cef_window.h"

namespace {

std::string GetStartURL() {
  const char* s = std::getenv("START_URL");
  return (s && *s) ? std::string(s) : "https://example.com";
}

class BareWindowDelegate : public CefWindowDelegate {
 public:
  explicit BareWindowDelegate(CefRefPtr<CefBrowserView> view) : view_(view) {}

  void OnWindowCreated(CefRefPtr<CefWindow> window) override {
    window->AddChildView(view_);
    window->CenterWindow(CefSize(1024, 700));

    // ---- Frameless (optional) ----
    // window->SetTitlebarHeight(0);
    // window->SetWindowButtonVisibility(false);
  }

  bool CanClose(CefRefPtr<CefWindow> window) override {
    return view_->GetBrowser()->GetHost()->TryCloseBrowser();
  }

 private:
  CefRefPtr<CefBrowserView> view_;
  IMPLEMENT_REFCOUNTING(BareWindowDelegate);
};

}  // namespace

SimpleApp::SimpleApp() {}

void SimpleApp::OnContextInitialized() {
  CEF_REQUIRE_UI_THREAD();

  CefBrowserSettings browser_settings;

  auto browser_view = CefBrowserView::CreateBrowserView(
      /*client=*/new SimpleHandler(false),
      /*url=*/GetStartURL(),
      browser_settings,
      /*request_context=*/nullptr,
      /*extra_info=*/nullptr,
      /*extension=*/nullptr);

  CefWindow::CreateTopLevelWindow(new BareWindowDelegate(browser_view));
}
