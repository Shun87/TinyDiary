
function initElement()
{
     // window.location.href="objc:caonima";//Call OC
    document.getElementById('content').onkeyup = onKeyboardUp;
    document.addEventListener('touchend', touchEnd, false);
    document.addEventListener("touchstart", touchStart, false);
    document.addEventListener("touchmove", touchMove, false);
}

var g_swip = false;   // 用来标志是否是swipe手势
var g_range;            
function touchStart(event)
{
    g_swip = false;
}

function touchMove(event)
{
    g_swip = true;
}

function touchEnd(event)
{
    if (!g_swip)
    {
        var touch = event.changedTouches.item(0);
        var touchX = touch.clientX;
        var touchY = touch.clientY;
        
        // Get the rect for the content
        var contentDIVRect = document.getElementById('content').getClientRects()[0];
        
        // 如果点击的是文本内容以外的内容，则默认光标在最后面， 如果在文本范围内，webView自己会去设置光标的位置
        if (!(touchX > contentDIVRect.left && touchY < contentDIVRect.bottom))
        {
            gotoEndOfDocument();
            document.getElementById('content').focus();
        }
    }
}

function saveRange()
{
    var selection2 = window.getSelection();
    g_range = selection2.getRangeAt(0).cloneRange();
}

function restoreRange()
{
    selection = window.getSelection();//get the selection object (allows you to change selection)
    selection.removeAllRanges();//remove any selections already made
    selection.addRange(g_range);//make the range you have just created the visible selection
}

function onKeyboardUp()
{
    var rec = getCaretClientPostion();
    window.location.href="cmd:scrollWindow@parameter&" + rec.y;
}

function setAttribute(name, value)
{
    var element = document.getElementById('content');
    element.setAttribute(name, value);
}

// 获取概述
function getGeneralText()
{
    var text = document.getElementById('content').textContent;
    if (text.length <= 100)
    {
        return text;
    }
    else
    {
        text = text.substring(0, 100);
    }
    return text;
}

function getCaretClientPostion()
{
    var x = 0;
    var y = 0;
    var rangeCount = window.getSelection().rangeCount;
    if (rangeCount > 0)
    {
        var range = window.getSelection().getRangeAt(0);
        var rectList = range.getClientRects();
        if (rectList.length > 0)
        {
            x = rectList[0].left;
            y = rectList[0].bottom;
        }
    }
    return { x: x, y: y };
}

function touchCoords(ev)
{
    if(ev.pageX || ev.pageY){
        
        return {x:ev.pageX, y:ev.pageY};
    }
    return{
        x:ev.clientX + document.body.scrollLeft - document.body.clientLeft,
        y:ev.clientY + document.body.scrollTop - document.body.clientTop
    };    
}  

function moveImageAtTo(x, y, newX, newY) {
    // Get our required variables
    var element  = document.elementFromPoint(x, y);
    if (element.toString().indexOf('Image') == -1) {
        // Attempt to move an image which doesn't exist at the point
        return;
    }
    var caretRange = document.caretRangeFromPoint(newX, newY);
    var selection = window.getSelection();
    
    // Save the image source so we know this later when we need to re-insert it
    var imageSrc = element.src;
    
    // Set the selection to the range of the image, so we can delete it
    var nodeRange = document.createRange();
    nodeRange.selectNode(element);
    selection.removeAllRanges();
    selection.addRange(nodeRange);
    
    // Delete the image
    document.execCommand('delete');
    
    // Set the selection to the caret range, so we can then add the image
    var selection = window.getSelection();
    var range = document.createRange();
    selection.removeAllRanges();
    selection.addRange(caretRange);
    
    // Re-insert the image
    document.execCommand('insertImage', false, imageSrc);
}

function setEndOfContenteditable(pos)
{
    var contentEditableElement= document.getElementById('content');
    var range,selection;
    if(document.createRange)//Firefox, Chrome, Opera, Safari, IE 9+
    {
        range = document.createRange();//Create a range (a range is a like the selection but invisible)
        range.selectNodeContents(contentEditableElement);//Select the entire contents of the element with the range
        //collapse the range to the end point. false means collapse to end rather than the start
        range.setStart(contentEditableElement.childNodes[0], pos);
        //range.setStart(contentEditableElement.childNodes[1], pos);
        range.collapse(true);
        selection = window.getSelection();//get the selection object (allows you to change selection)
        selection.removeAllRanges();//remove any selections already made
        selection.addRange(range);//make the range you have just created the visible selection
    }
}

function setCursorPos(pos)
{
    var textNode = document.getElementById('content').childNodes[0];
   var textNode2 = document.getElementById('content').childNodes[1].childNodes[0];
    var range = document.createRange();
    if (pos < 15)
    {
        range.setStart(textNode, pos);

    }
    else{
    range.setStart(textNode2, pos-15);
    }
    range.collapse(true);
    var sel = window.getSelection();
    sel.removeAllRanges();
    sel.addRange(range);

}

function gotoEndOfDocument()
{
    var contentEditableElement = document.getElementById('content');
    var range,selection;
    range = document.createRange();//Create a range (a range is a like the selection but invisible)
    range.selectNodeContents(contentEditableElement);//Select the entire contents of the element with the range
    range.collapse(false);//collapse the range to the end point. false means collapse to end rather than the start
    selection = window.getSelection();//get the selection object (allows you to change selection)
    selection.removeAllRanges();//remove any selections already made
    selection.addRange(range);//make the range you have just created the visible selection
}