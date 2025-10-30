// Patched cefsimple simple_app.cc
// Hardcodes the startup URL via START_URL env var (default: https://example.com)

#include "simple_app.h"
#include "simple_handler.h"

#include "include/cef_app.h"
#include "include/cef_browser.h"
#include "include/cef_command_line.h"
#include "include/cef_scheme.h"
#include "include/wrapper/cef_helpers.h"

#include <cstdlib>

namespace {

std::string GetStartURL() {
  const char* env = std::getenv("START_URL");
  if (env && *env) return std::string(env);
  return "https://example.com";
}

}  // namespace

SimpleApp::SimpleApp() {}

void SimpleApp::OnRegisterCustomSchemes(CefRawPtr<CefSchemeRegistrar> registrar) {
  // No custom schemes.
}

#if defined(OS_WIN) || defined(OS_LINUX) || defined(OS_MACOSX)
void SimpleApp::OnBeforeCommandLineProcessing(
    const CefString& process_type, CefRefPtr<CefCommandLine> command_line) {
  // Example tweak: disable GPU if desired.
  // command_line->AppendSwitch("disable-gpu");
}
#endif

void SimpleApp::OnContextInitialized() {
  CEF_REQUIRE_UI_THREAD();

  CefRefPtr<SimpleHandler> handler(new SimpleHandler(false));
  CefBrowserSettings browser_settings;

  CefWindowInfo window_info;
#if defined(OS_WIN)
  window_info.SetAsPopup(NULL, "cefsimple");
#endif

  const std::string url = GetStartURL();

  CefBrowserHost::CreateBrowser(window_info, handler, url, browser_settings,
                                nullptr, nullptr);
}
