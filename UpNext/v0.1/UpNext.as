package {

	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.text.*;
	import flash.accessibility.*;
	import flash.net.*


	public class UpNext {

		private var textArray: Array;
		private var timeArray: Array;
		private var clock: TextField;
		private var ticker: TextField;

		public function UpNext(te: Array, ti: Array, cl: TextField, tx: TextField) {
			this.textArray = te;
			this.timeArray = ti;
			this.clock = cl;
			this.ticker = tx;
		}

		public function initText(): void {
			for each(var text: TextField in this.textArray) {
				text.text = "test text"
			}

			for each(var time: TextField in this.timeArray) {
				time.text = "12:00 AM"
			}
		}

		public function initClock(): void {
			this.clock.text = getFormattedTime();

			var clockTimer: Timer = new Timer(100, 0);
			clockTimer.addEventListener(TimerEvent.TIMER, onClockTimer);
			clockTimer.start();
		}
		
		public function initTicker(): void {
			this.ticker.text = "This is example ticker text. There should be 66 characters here..."
		}
		
		public function tickerHide(): void {
			this.ticker.visible = false
		}
		public function tickerShow(): void {
			this.ticker.visible = true;
		}

		private function onClockTimer(e: TimerEvent): void {
			this.clock.text = getFormattedTime();
		}

		private function getFormattedTime(): String {
			var now: Date = new Date();
			var hrs: String = String(now.getHours());
			if (hrs.length < 2) {
				hrs = "0" + hrs;
			}
			var mins: String = String(now.getMinutes());
			if (mins.length < 2) {
				mins = "0" + mins;
			}
			var secs: String = String(now.getSeconds());
			if (secs.length < 2) {
				secs = "0" + secs;
			}
			if (now.getMilliseconds() > 500) {
				return hrs + ":" + mins + ":" + secs;
			} else {
				return hrs + " " + mins + " " + secs;
			}
		}
		
	}

}