import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;
import Toybox.System;
import Toybox.WatchUi;

// CIQTools - Number Picker
module CIQToolsNumberPicker {

    class PickerButton extends WatchUi.Drawable {

        const SELECTED_COLOR = Graphics.COLOR_WHITE;

        private var _text as String;
        private var _posX as Number;
        private var _posY as Number;
        private var _height as Number;
        private var _width as Number;
        private var _cornerRadius as Number;
        private var _font as FontDefinition;
        private var _bgColor as Number?;
        private var _isSelected as Boolean;

        function initialize(params as { :identifier as Lang.Object, :locX as Lang.Numeric, :locY as Lang.Numeric, :width as Lang.Numeric, :height as Lang.Numeric, :visible as Lang.Boolean }) {
            Drawable.initialize(params);
            _text = params[:text] as String;
            _posX = params[:xpos] as Number;
            _posY = params[:ypos] as Number;
            _height = params[:height] as Number;
            _width = params[:width] as Number;
            _font = params[:font] as FontDefinition;
            _bgColor = params[:bgcolor] as ColorType;
            _cornerRadius = Math.round(_width * 0.08).toNumber();
            _isSelected = false;
        }

        function draw(dc as Dc) as Void {
            // if the button selected (from button manipulation)?
            if (_isSelected) {
                dc.setColor(SELECTED_COLOR, Graphics.COLOR_TRANSPARENT);
            } else {
                dc.setColor(_bgColor != null ? _bgColor : Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
            }
            dc.fillRoundedRectangle(_posX-(_width/2), _posY-(_height/2), _width, _height, _cornerRadius);
            if (_isSelected) {
                dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
            } else {
                dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            }
            dc.drawText(_posX, _posY, _font, _text, Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
            // if the button selected (from button manipulation)?
            if (_isSelected) {
                dc.setPenWidth(2);
                dc.setColor(SELECTED_COLOR, Graphics.COLOR_TRANSPARENT);
                dc.drawRoundedRectangle(_posX-(_width/2), _posY-(_height/2), _width, _height, _cornerRadius);
            }
        }

        function isWithin(coords as Array<Number>) as Boolean {
            if (coords[0] >= (_posX-(_width/2)) && coords[0] <= (_posX+(_width/2)) && coords[1] >= (_posY-(_height/2)) && coords[1] <= (_posY+(_height/2))) {
                return true;
            }
            return false;
        }

        function setIsSelected(isSelected as Boolean) as Void {
            _isSelected = isSelected;
        }
    }

}
