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

    //! TODO - describe class here
    class GenericNumberPickerDelegate extends WatchUi.BehaviorDelegate {

        protected var _view as GenericNumberPicker;
        protected var _selectedButton as Number;
        protected var _displayStr as String;
        protected var _numberStr as String;
        protected var _minLength as Number = 1;
        protected var _maxLength as Number = 10;
        protected var _selectOkAtMin as Boolean = false;

        //! Constructor
        function initialize(view as GenericNumberPicker) {
            BehaviorDelegate.initialize();
            _view = view;
            _selectedButton = view._selectedButton;
            _numberStr = "";
            _displayStr = "";
        }

        //! TODO - describe function here
        function onKey(event as KeyEvent) as Boolean {
            var key = event.getKey();
            if (key == WatchUi.KEY_ENTER || key == WatchUi.KEY_START) {
                selectionMade();
                return true;
            } else if (key == WatchUi.KEY_ESC || key == WatchUi.KEY_LAP) {
                return onBack();
            } else if (key == WatchUi.KEY_UP || key == WatchUi.KEY_MODE) {
                return onPreviousPage();
            } else if (key == WatchUi.KEY_DOWN || key == WatchUi.KEY_CLOCK) {
                return onNextPage();
            }
            return false;
        }

        //! TODO - describe function here
        function onTap(clickEvent as ClickEvent) as Boolean {
            if (clickEvent.getType() == WatchUi.CLICK_TYPE_TAP) {
                var coords = clickEvent.getCoordinates();
                // FIXME - there needs to be a better way to do this... maybe a callback from the buttons??
                // determine which button was pressed (if any)
                var buttonID;
                var buttonPressed = false;
                for (var i=1; i <= 12; i++) {
                    buttonID = "";
                    if (i <= 9) {
                        buttonID = "Number"+i;
                    } else if (i == 10) {
                        buttonID = "Number0";
                    } else if (i == 11) {
                        buttonID = "OkayLabel";
                    } else if (i == 12) {
                        buttonID = "DeleteLabel";
                    }

                    var pickerButton = _view.findDrawableById(buttonID) as PickerButton;
                    if (pickerButton != null && pickerButton.isWithin(coords)) {
                        buttonPressed = true;
                        _selectedButton = i;
                        break;
                    }
                }

                // highlight the button tapped and capture selection (unless the maximum length has been reached)
                if (buttonPressed && _selectedButton != null && (_numberStr.length() < _maxLength || _selectedButton >= 11)) {
                    _view.highlightButton(_selectedButton);
                    selectionMade();
                }
            }
            return (true);
        }

        //! TODO - describe function here
        function selectionMade() as Void {
            if (_selectedButton == 11) {
                if (_numberStr.length() >= _minLength) {
                    onAccept(_numberStr);
                }
            } else if (_selectedButton == 12) {
                _numberStr = _numberStr.substring(0,_numberStr.length()-1) as String;
            } else {
                _numberStr = _numberStr + (_selectedButton == 10 ? "0" : _selectedButton.toString());
                if ((_selectOkAtMin && _numberStr.length() >= _minLength) || (_numberStr.length() >= _maxLength)) {
                    _selectedButton = 11;
                    _view.highlightButton(_selectedButton);
                }
            }
            _displayStr = formatInputForDisplay(_numberStr);
            _view.setTitle(_displayStr);
            WatchUi.requestUpdate();
        }

        //! TODO - describe function here
        function onPreviousPage() as Boolean {
            var newButton = 12; // default to 12, if no button is selected already
            // don't let the user select more than the specified maximum number of digits
            if (_numberStr.length() < _maxLength) {
                if (_selectedButton != null) {
                    newButton = _selectedButton - 1;
                    if (newButton < 1) {
                        newButton = 12;
                    }
                }
            } else {
                // if already at maximum digits, then flip-flop between OK and delete (defaulting to OK)
                newButton = (_selectedButton == 11 ? 12 : 11);
            }
            _selectedButton = newButton;
            _view.highlightButton(_selectedButton);
            WatchUi.requestUpdate();
            return true;
        }

        //! TODO - describe function here
        function onNextPage() as Boolean {
            var newButton = 1;  // default to 1, if no button is selected already
            // don't let the user select more than the specified maximum number of digits
            if (_numberStr.length() < _maxLength) {
                if (_selectedButton != null) {
                    newButton = _selectedButton + 1;
                    if (newButton > 12) {
                        newButton = 1;
                    }
                }
            } else {
                // if already at maximum digits, then flip-flop between OK and delete (defaulting to OK)
                newButton = (_selectedButton == 11 ? 12 : 11);
            }
            _selectedButton = newButton;
            _view.highlightButton(_selectedButton);
            WatchUi.requestUpdate();
            return true;
        }

        //! TODO - describe function here
        function onBack() as Boolean {
            WatchUi.popView(WatchUi.SLIDE_RIGHT);
            return true;
        }

        //! TODO - describe function here
        function onAccept(numberStr as String) as Void {
            // THIS MUST BE OVERRIDDEN
            WatchUi.popView(WatchUi.SLIDE_RIGHT);
        }

        //! TODO - describe function here
        function formatInputForDisplay(numberStr as String) as String {
            return (numberStr);
        }
    }

}
