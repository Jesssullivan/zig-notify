/*
 * send_notification.c -- zig-notify C FFI usage example
 *
 * Demonstrates init, send (with body and title-only), and deinit.
 *
 * Build (after zig build):
 *   macOS:  cc -o send_notification send_notification.c -Iinclude -Lzig-out/lib -lzig-notify
 *   Linux:  cc -o send_notification send_notification.c -Iinclude -Lzig-out/lib -lzig-notify -lnotify -lglib-2.0 -lgobject-2.0
 */

#include "zig_notify.h"
#include <string.h>
#include <stdio.h>

int main(void) {
    /* Initialize (required on Linux, no-op on macOS) */
    const char *app = "zig-notify-example";
    if (zig_notify_init(app, strlen(app)) != 0) {
        fprintf(stderr, "zig_notify_init failed\n");
        return 1;
    }

    /* Send a notification with title and body */
    const char *title = "Build Complete";
    const char *body  = "Release build finished successfully";
    if (zig_notify_send(title, strlen(title), body, strlen(body),
                        ZIG_NOTIFY_URGENCY_NORMAL) != 0) {
        fprintf(stderr, "zig_notify_send failed\n");
    }

    /* Send a title-only notification */
    const char *alert = "Warning: disk space low";
    if (zig_notify_send(alert, strlen(alert), NULL, 0,
                        ZIG_NOTIFY_URGENCY_CRITICAL) != 0) {
        fprintf(stderr, "zig_notify_send (title-only) failed\n");
    }

    /* Cleanup (required on Linux, no-op on macOS) */
    zig_notify_deinit();

    return 0;
}
