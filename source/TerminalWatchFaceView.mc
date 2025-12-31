using Toybox.WatchUi as WatchUi;
using Toybox.Graphics as Graphics;
using Toybox.System as System;
using Toybox.Time as Time;
using Toybox.Time.Gregorian as Gregorian;
using Toybox.Lang as Lang;
using Toybox.Activity as Activity;
using Toybox.ActivityMonitor as ActivityMonitor;
using Toybox.Math as Math;

class TerminalWatchFaceView extends WatchUi.WatchFace {

  var monoFont = null;

  function initialize() {
    WatchUi.WatchFace.initialize();
  }

  function onUpdate(dc) {

    // Load the font
    if (monoFont == null) {
      monoFont = WatchUi.loadResource(Rez.Fonts.RobotoMono28);
    }
    var font = monoFont;

    // Clear screen
    dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
    dc.clear(); // clears with background color :contentReference[oaicite:1]{index=1}

    var w = dc.getWidth();
    var h = dc.getHeight();
    var x = (w * 0.12).toNumber(); // % from left
    var y = (h * 0.20).toNumber(); // % from top
    var lineH = dc.getFontHeight(font) + 2;

    // Build strings
    var clock = System.getClockTime();
    var timeStr = formatTime(clock);
    var dateStr = formatDate();
    var battStr = formatBatt(System.getSystemStats().battery);
    var stepsStr = formatSteps();
    var hrStr = formatCurrentHeartRate();

    // Draw lines
    y = drawLine(dc, x, y, font, Graphics.COLOR_WHITE, "user@watch:~ $ now");  y += lineH;

    // fixed offset so value appears after the tag — adjust 60 up or down
    var indent = 120;

    // TIME
    dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
    dc.drawText(x, y, font, "[TIME] ", Graphics.TEXT_JUSTIFY_LEFT);
    dc.setColor(0x00FFFF, Graphics.COLOR_TRANSPARENT);
    dc.drawText(x + indent, y, font, formatTime(clock), Graphics.TEXT_JUSTIFY_LEFT);
    y += lineH;

    // DATE
    dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
    dc.drawText(x, y, font, "[DATE] ", Graphics.TEXT_JUSTIFY_LEFT);
    dc.setColor(0xFFFF66, Graphics.COLOR_TRANSPARENT);
    dc.drawText(x + indent, y, font, dateStr, Graphics.TEXT_JUSTIFY_LEFT);
    y += lineH;

    // BATT
    dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
    dc.drawText(x, y, font, "[BATT] ", Graphics.TEXT_JUSTIFY_LEFT);
    dc.setColor(0x66FF66, Graphics.COLOR_TRANSPARENT);
    dc.drawText(x + indent, y, font, battStr, Graphics.TEXT_JUSTIFY_LEFT);
    y += lineH;

    // STEPS
    dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
    dc.drawText(x, y, font, "[STEP] ", Graphics.TEXT_JUSTIFY_LEFT);
    dc.setColor(0xFFAA00, Graphics.COLOR_TRANSPARENT);
    dc.drawText(x + indent, y, font, stepsStr, Graphics.TEXT_JUSTIFY_LEFT);
    y += lineH;

    // HR
    dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
    dc.drawText(x, y, font, "[C_HR] ", Graphics.TEXT_JUSTIFY_LEFT);
    dc.setColor(0xFF4444, Graphics.COLOR_TRANSPARENT);
    dc.drawText(x + indent, y, font, hrStr, Graphics.TEXT_JUSTIFY_LEFT);
    y += lineH;

    // footer
    drawLine(dc, x, y, font, Graphics.COLOR_WHITE, "user@watch:~ $");
  }

  function drawLine(dc, x, y, font, fg, s) {
    dc.setColor(fg, Graphics.COLOR_TRANSPARENT);
    dc.drawText(x, y, font, s, Graphics.TEXT_JUSTIFY_LEFT);
    return y;
  }


  function formatTime(clock) {
    var hour = clock.hour;
    var ampm = " AM";

    if (hour >= 12) {
      ampm = " PM";
    }
    hour = hour % 12;
    if (hour == 0) {
      hour = 12;
    }

    return hour.format("%02d") + ":" +
      clock.min.format("%02d") + ":" +
      clock.sec.format("%02d") + ampm;
  }

  function formatDate() {
    var info = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
    return Lang.format("$1$ $2$ $3$ $4$", [
        info.day_of_week,
        info.month,
        info.day.format("%02d"),
        info.year.format("%04d")
    ]);
  }

  function formatBatt(batt) {
    // batt is a Float percent; Float.toNumber() is supported :contentReference[oaicite:3]{index=3}
    var pct = batt.toNumber();
    if (pct < 0) {
      pct = 0;
    }
    if (pct > 100) {
      pct = 100;
    }

    var totalBars = 10;
    var filled = Math.floor((pct * totalBars) / 100); // Math.floor exists :contentReference[oaicite:4]{index=4}

  var bars = "";
  var i = 0;
  while (i < totalBars) {
    if (i < filled) {
      bars += "#";
    } else {
      bars += ".";
    }
    i += 1;
  }

  return "[" + bars + "]" + pct.format("%d") + "%";
  }

  function formatSteps() {
    var mi = ActivityMonitor.getInfo();
    if (mi == null || mi.steps == null) {
      return "- steps";
    }
    return mi.steps.format("%d") + " steps";
  }

  function formatCurrentHeartRate() {
    // Prefer currentHeartRate when available
    var ai = Activity.getActivityInfo();
    if (ai != null && ai.currentHeartRate != null && ai.currentHeartRate > 0) {
      return ai.currentHeartRate.format("%d") + " bpm";
    }

    // Fallback: last HR sample
    var it = ActivityMonitor.getHeartRateHistory(1, true);
    if (it != null) {
      var s = it.next();
      if (s != null && s.heartRate != null && s.heartRate > 0) {
        return s.heartRate.format("%d") + " bpm";
      }
    }

    return "- bpm";
  }
}

