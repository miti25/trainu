
document.addEventListener('turbolinks:load', function() {
  // howtos表示制限
  const howtos_limit = 8
  let howtos_array = Array.from(document.querySelectorAll('.howto'))
  let howtos_length = howtos_array.length
  // 左右移動メソッド（direciton= 1(right) or -1(left)）
  function move_howto(obj, direction){
    const target_howto = obj.target.closest('.howto');
    const target_index = howtos_array.findIndex(index => index == target_howto)
    const replaced_index = target_index + direction
    const replace_howto = howtos_array[replaced_index]
    replace_howto.querySelector('.index_text').textContent = target_index + 1;
    replace_howto.querySelector('.order_num').value = target_index;
    replace_howto.setAttribute('class', `nested-fields col-3 mt-5 howto order-${target_index}`);

    target_howto.querySelector('.index_text').textContent = replaced_index+ 1;
    target_howto.querySelector('.order_num').value = replaced_index;
    target_howto.setAttribute('class', `nested-fields col-3 mt-5 howto order-${replaced_index}`);
    let end_index = []
    if(direction == 1){
      end_index = target_index
      howtos_array.splice(target_index, 2, howtos_array[replaced_index], howtos_array[target_index])
    } else if(direction == -1){
      end_index = replaced_index
      howtos_array.splice(replaced_index, 2, howtos_array[target_index], howtos_array[replaced_index])
    }
    if (end_index == 0){
      howtos_array[end_index].querySelector('.move_left').style.display ='none';
      howtos_array[end_index +1].querySelector('.move_left').style.display ='block';
    };
    if (end_index + 1 == howtos_length -1) {
      howtos_array[end_index +1].querySelector('.move_right').style.display ='none';
      howtos_array[end_index].querySelector('.move_right').style.display ='block';
    };
  };
  // howto表示限界到達時、追加ボタン非表示
  if (howtos_length >= howtos_limit) document.getElementById('add_howto').style.display ='none';
  // howtoの左右移動ボタン
  document.querySelectorAll('.move_left').forEach(function(a){
    if (a.closest('.order-0')) a.style.display ='none';
    a.addEventListener('click', function(e){
      move_howto(e, -1)
    });
  });
  document.querySelectorAll('.move_right').forEach(function(a){
    if (howtos_array.findIndex(index => index == a.closest('.howto')) + 1  == howtos_length){
      a.style.display ='none';
    };
    a.addEventListener('click', function(e){
      move_howto(e, 1)
    });
  });
  // howto画像プレビュー表示
  const howtos_uploader = document.querySelectorAll('.howto_uploader');
  howtos_uploader.forEach(function(a){
    a.addEventListener('change', function(e) {
      const file = e.target.files[0];
      const reader = new FileReader();
      reader.readAsDataURL(file);
      reader.onload = function() {
        const image = reader.result;
        const preview = e.target.closest('.howto').querySelector('.howto_preview')
        preview.setAttribute('src', image);
        preview.setAttribute('class', 'howto_preview mini d-block mx-auto');
      }
    });
  });
  // howto詳細文字数カウント
  const howtos_description = document.querySelectorAll('.howto_description');
  howtos_description.forEach(function(a){
    a.onkeyup = function(e){
      const max = 100;
      const word_count = max - e.target.value.length;
      const counter = e.target.closest('.howto').querySelector('.word_count');
      counter.innerHTML = '残り' + word_count + '文字';
    };
  });
  // gem:cocoon フォーム削除後
  jQuery('#howtos_area').on('cocoon:after-remove', function(e, removedItem){
    jQuery(removedItem).removeClass();
    howtos_array = jQuery('.howto').toArray();
    howtos_length = howtos_array.length;
    if (howtos_length <= howtos_limit) jQuery('#add_howto').show();
    jQuery(howtos_array[0]).find('.move_left').hide();
    jQuery(howtos_array[howtos_length - 1]).find('.move_right').hide();
    jQuery(howtos_array[howtos_length - 2]).find('.move_right').show();
    jQuery('.howto').each(function(key, a){
      jQuery(a).find('.index_text').text(key +1);
      jQuery(a).find('.order_num').val(key);
      jQuery(a).attr('class', `nested-fields col-3 mt-5 howto order-${key}`);
    });
  });

  // gem:cocoon 新規フォーム作成後
  jQuery('.links').on('cocoon:after-insert', function(e, insertedItem){
    howtos_array = jQuery('.howto').toArray()
    howtos_length = howtos_array.length
    const previous_index = jQuery(howtos_array).index(jQuery('.howto').eq(-2));
    // リミット到達時フォーム追加ボタン非表示
    if (previous_index >= howtos_limit - 2) jQuery('#add_howto').hide();
    if (jQuery('.howto').length == 1){
      var index =  0
    } else {
      var index = Number(previous_index) + 1
    };
    // 表示順指定
    jQuery(insertedItem).find('.index_text').text(index + 1);
    jQuery(insertedItem).find('.order_num').val(index);
    jQuery(insertedItem).removeClass('order-');
    jQuery(insertedItem).addClass(`order-${index}`);
    //画像プレビュー表示
    jQuery(insertedItem).find('.howto_uploader').on('change', function(e){
      const file = e.target.files[0];
      const reader = new FileReader();
      reader.readAsDataURL(file);
      reader.onload = function() {
        const image = reader.result;
        const preview = jQuery(insertedItem).find('.howto_preview');
        preview.attr('src', image);
        preview.attr('class', 'howto_preview mini d-block mx-auto');
      }
    });
    // 文字数カウント
    const howto_description = jQuery(insertedItem).find('.howto_description');
    howto_description.keyup(function(){
      const max = 100;
      const word_count = max - howto_description.val().length;
      jQuery(insertedItem).find('.word_count').html(`残り${word_count}文字`);
    });
    // 左右移動
    jQuery(insertedItem).find('.move_left').on('click', function(e){
      move_howto(e, -1)
    });
    jQuery(insertedItem).find('.move_right').on('click', function(e){
      move_howto(e, 1)
    });
    //リミット時の左右移動キー表示
    if (jQuery(insertedItem).hasClass('order-0')) {
      jQuery(insertedItem).find('.move_left').hide()
    } else {
      jQuery('.howto').find('.move_right').show()
      jQuery(insertedItem).find('.move_right').hide()
    };
  });
});