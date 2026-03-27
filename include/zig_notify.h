#ifndef ZIG_NOTIFY_H
#define ZIG_NOTIFY_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

/* ── Notification Types ──────────────────────────────────────────────── */

/** Urgency level for notifications. */
typedef enum {
    ZIG_NOTIFY_URGENCY_LOW = 0,
    ZIG_NOTIFY_URGENCY_NORMAL = 1,
    ZIG_NOTIFY_URGENCY_CRITICAL = 2,
} zig_notify_urgency_t;

/* ── Core API ────────────────────────────────────────────────────────── */

/**
 * Send a notification.
 *
 * @param title         Notification title.
 * @param title_len     Length of title string.
 * @param body          Notification body text (may be NULL).
 * @param body_len      Length of body string (0 if NULL).
 * @param urgency       Urgency level.
 * @return              0 on success, -1 on failure.
 *
 * macOS: UNUserNotificationCenter (requestAuthorization + add)
 * Linux: libnotify notify_notification_new + notify_notification_show
 */
int zig_notify_send(
    const char *title, size_t title_len,
    const char *body, size_t body_len,
    zig_notify_urgency_t urgency
);

/**
 * Request notification permission (macOS only, no-op on Linux).
 *
 * @return  0 if granted, -1 if denied, -2 on error.
 *
 * macOS: UNUserNotificationCenter.requestAuthorization
 * Linux: Always returns 0 (no permission model)
 */
int zig_notify_request_permission(void);

/**
 * Initialize the notification system.
 * Must be called before zig_notify_send on Linux (calls notify_init).
 * No-op on macOS.
 *
 * @param app_name      Application name.
 * @param app_name_len  Length of app name string.
 * @return              0 on success, -1 on failure.
 */
int zig_notify_init(const char *app_name, size_t app_name_len);

/**
 * Clean up notification resources.
 * Should be called on app exit on Linux (calls notify_uninit).
 * No-op on macOS.
 */
void zig_notify_deinit(void);

#ifdef __cplusplus
}
#endif

#endif /* ZIG_NOTIFY_H */
