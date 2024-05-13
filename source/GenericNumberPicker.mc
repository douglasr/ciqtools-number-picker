/*
MIT License

Copyright (c) 2023-2024 Douglas Robertson & REFSIX Ltd

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

// CIQTools - Number Picker
module CIQToolsNumberPicker {

    class GenericNumberPicker extends WatchUi.View {

        var _textHint as String;
        var _title as String?;
        var _selectedButton as Number?;

        function initialize(selectedButton as Number?, textHint as String?) {
            View.initialize();
            _selectedButton = selectedButton;
            if (textHint != null) {
                _textHint = textHint;
            } else {
                _textHint = "";
            }
        }

        function onLayout(dc as Dc) as Void {
            if (_selectedButton) {
                var button = View.findDrawableById(getButtonID(_selectedButton)) as PickerButton;
                button.setIsSelected(true);
            }
        }

        function onUpdate(dc as Dc) as Void {
            // clear the screen
            dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
            dc.clear();

            var titleLabel = View.findDrawableById("TitleLabel") as Text;
            if (_title != null && !_title.equals("")) {
                titleLabel.setColor(Graphics.COLOR_WHITE);
                titleLabel.setText(_title);
            } else {
                titleLabel.setColor(Graphics.COLOR_LT_GRAY);
                titleLabel.setText(_textHint);
            }

            // call the update
            View.onUpdate(dc);
        }

        function setTitle(title as String) as Void {
            _title = title;
            WatchUi.requestUpdate();
        }

        function highlightButton(selectedButton as Number) as Void {
            // un-select the current button (if there is a selection)
            if (_selectedButton != null) {
                var currButton = View.findDrawableById(getButtonID(_selectedButton)) as PickerButton;
                currButton.setIsSelected(false);
            }
            // select the requested new button
            _selectedButton = selectedButton;
            var newButton = View.findDrawableById(getButtonID(_selectedButton)) as PickerButton;
            newButton.setIsSelected(true);
        }

        function getButtonID(buttonNumber as Number) as String {
            if (buttonNumber >= 1 && buttonNumber <= 9) {
                return ("Number" + buttonNumber);
            } else if (buttonNumber == 10) {
                return ("Number0");
            } else if (buttonNumber == 11) {
                return ("OkayLabel");
            } else if (buttonNumber == 12) {
                return ("DeleteLabel");
            }
            return ("Button5");
        }
    }

}
