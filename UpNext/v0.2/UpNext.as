package {

	import flash.accessibility.*;
	import flash.events.*;
	import flash.utils.*;
	import se.svt.caspar.template.CasparTemplate;

	public class UpNext extends CasparTemplate {

		private var clockTimer: Timer;
		private var tickerArray: Array = new Array();
		private var tickerIndex: int = 0;
		private var debug: Boolean = RuntimeCheck.isDebugBuild();
		private const customParameterDescription:XML = 	
														<parameters>
														   <parameter id="table" type="xml" info="Six lines of up next times and descriptions" />
														   <parameter id="ticker" type="xml" info="Three lines of text for the ticker" />
														</parameters>;
		public function UpNext() {
			// constructor code
			this.debugTrace("UpNext()", "Debug build");
			if (this.debug) {
				testData();
			}
			initClock();
		}

		public override function SetData(xmlData: XML): void {
			this.debugTrace("SetData()", "Called");

			for each(var element: XML in xmlData.elements()) {
				if (element.@id == "table") {
					buildTable(new XML(element));
				}

				if (element.@id == "ticker") {
					buildTicker(new XML(element));
				}
				
				if (element.@id == "debug") {
					if (element.data.@value == "true") {
						this.debug = true;
						testData();	
					} else {
						this.debug = false;
					}
				}
			}
		}

		public override function preDispose(): void {
			this.debugTrace("preDispose()", "Called");
			this.disposeClock();
		}

		public function tickerCallback(): void {
			this.debugTrace("tickerCallback()", "Called");
			if (this.tickerIndex > tickerArray.length - 1) {
				this.debugTrace("tickerCallback()", "index reset");
				tickerIndex = 0;
			}
			this.debugTrace("tickerCallback()", "displaying index: " + tickerIndex + " || " + tickerArray[tickerIndex]);
			container.ticker.ticker.xTicker.text = tickerArray[tickerIndex] || "";
			tickerIndex++;
		}

		public function stopCallback(): void {
			this.Stop();
		}

		private function testData(): void {
			this.debugTrace("testData()", "Called");
			container.clock.xClock.text = "22:22:22 PM"

			var xmlIn: XML = new XML(
				<templateData>
					<componentData id="table">
						<data id="line_1" time="8:00 AM" text="Ducktales" />
						<data id="line_2" time="8:30 AM" text="Ducktales" />
						<data id="line_3" time="9:00 AM" text="Thundercats" />
						<data id="line_4" time="9:30 AM" text="Thundercats" />
						<data id="line_5" time="10:00 AM" text="Transformers" />
						<data id="line_6" time="10:30 AM" text="Transformers" />
					</componentData>
					<componentData id="ticker">
						<data id="ticker_1" text="Subscribe to Aesthetic TV for live updates!" />
						<data id="ticker_2" text="Comment with what you'd like to see in our lineup" />
						<data id="ticker_3" text="Donate to Aesthetic TV if you like what we're doing" />
					</componentData>
				</templateData>
			);

			SetData(xmlIn);
		}

		private function buildTable(results: XML): void {
			this.debugTrace("buildTable()", "Called");
			var currentEntry: entry;

			for each(var element: XML in results.elements()) {
				this.debugTrace("buildTable()", "-for each -", element.@id, element.@time, element.@text);
				if (container.table.getChildByName(element.@id) != null) {
					currentEntry = container.table.getChildByName(element.@id) as entry;
					currentEntry.text.xText.text = element.@text;
					currentEntry.time.xTime.text = element.@time;
				}
			}
		}

		private function buildTicker(results: XML): void {
			this.debugTrace("buildTicker()", "Called");
			for each(var element: XML in results.elements()) {
				this.debugTrace("buildTicker()", "-for each -", element.@text);
				tickerArray.push(element.@text);
			}
		}

		private function initClock(): void {
			this.debugTrace("initClock()", "Called");
			container.clock.xClock.text = clockTime();

			clockTimer = new Timer(100, 0);
			clockTimer.addEventListener(TimerEvent.TIMER, onClockTimer);
			clockTimer.start();
		}

		private function disposeClock(): void {
			this.debugTrace("disposeClock()", "Called");
			clockTimer.stop();
			clockTimer.removeEventListener(TimerEvent.TIMER, onClockTimer);
		}

		private function onClockTimer(e: TimerEvent): void {
			// this.debugTrace("onClockTimer()", "Called");
			container.clock.xClock.text = clockTime();
		}

		private function clockTime(): String {
			// this.debugTrace("clockTime()", "Called");
			var now: Date = new Date();
			var am_pm: String = "AM"

			var hrs: String = String(now.getHours());
			if (now.getHours() >= 12) {
				am_pm = "PM"
				if (now.getHours() > 12) {
					hrs = String(now.getHours() - 12)
				}
			} else if (now.getHours() == 0) {
				hrs = "12"
			}
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
				return hrs + ":" + mins + ":" + secs + " " + am_pm;
			} else {
				return hrs + " " + mins + " " + secs + " " + am_pm;
			}
		}

		private function debugTrace(fnName: String, ...paramIn): void {
			if (!this.debug) {
				return
			}
			super.TraceToLog("[" + fnName + "] " + paramIn.join(" "));
			trace("[" + fnName + "]", paramIn);
		}

	}

}