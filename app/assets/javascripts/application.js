// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
// require jquery
// require bootstrap
//= require turbolinks
//= require_tree .


/* global $ */
/* global Clipboard */
/* global ready */
//初回読み込み、リロード、ページ切り替えで動く。
$(document).on('turbolinks:load', function() { });


//= require clipboard
$(document).ready(function(){  
  
  var clipboard = new Clipboard('.clipboard-btn');
  console.log(clipboard);
	
});

$(document).on('turbolinks:load', function(){  
  
  var clipboard = new Clipboard('.clipboard-btn');
  console.log(clipboard);
	
});


$(document).ready(ready)
$(document).on('page:load', ready)

$.fn.modal.Constructor.prototype._enforceFocus = function() {
  
  var clipboard = new Clipboard('.clipboard-btn');
  console.log(clipboard);
	
};


$(function() {
  $('#js-copybtn').on('click', function(){
    // コピーする文章の取得
    let text = $('#js-copytext').text();
    // テキストエリアの作成
    let $textarea = $('<textarea></textarea>');
    // テキストエリアに文章を挿入
    $textarea.text(text);
    //　テキストエリアを挿入
    $(this).append($textarea);
    //　テキストエリアを選択
    $textarea.select();
    // コピー
    document.execCommand('copy');
    // テキストエリアの削除
    $textarea.remove();
    // アラート文の表示
    $('#js-copyalert').show().delay(2000).fadeOut(400);
  });
});