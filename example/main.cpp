#include "client/linux/handler/exception_handler.h"

static void crash()
{
    volatile int *a = (int *)nullptr;
    *a = 1;
}

int main() {
    google_breakpad::MinidumpDescriptor descriptor(".");
    google_breakpad::ExceptionHandler eh(
        descriptor, nullptr, [](const google_breakpad::MinidumpDescriptor &descriptor, void *context, bool succeeded) {
            printf("state: %d path: %s\n", succeeded, descriptor.path());
            return succeeded;
        },
        nullptr, true, -1);

    crash();

    return 0;
}
