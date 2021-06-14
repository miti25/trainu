
document.addEventListener('turbolinks:load', function() {
  document.querySelectorAll('.delete').forEach(function(a) {
    a.addEventListener('ajax:success', function() {
      a.style.display = 'none';
    });
  });
  const uploader = document.querySelector('.recipe_uploader');
    uploader.addEventListener('change', function() {
      const file = uploader.files[0];
      const reader = new FileReader();
      reader.readAsDataURL(file);
      reader.onload = function() {
        const image = reader.result;
        document.querySelector('.recipe_preview').setAttribute('src', image);
        document.querySelector('.recipe_preview').setAttribute('class', 'thumbnail');
      }
    });
  document.querySelectorAll('.howto_uploader').forEach(function(a) {
    a.addEventListener('change', function() {
      const file = a.files[0];
      const reader = new FileReader();
      reader.readAsDataURL(file);
      reader.onload = function() {
        const image = reader.result;
        document.querySelector('.howto_preview').setAttribute('src', image);
        document.querySelector('.howto_preview').setAttribute('class', 'mini');
      }
    });
  });
  function buildField(index) {  // 追加するフォームのｈｔｍｌを用意
    const html = `<div class="col-3 js_howto_group" data-index="${index}">
                    <div class="text-right">
                      <span class="delete_btn">削除</span>
                      <span class="ml-3 add_btn">追加</span>
                    </div>
                    <input class="howto_uploader howto_${index}" type="file" name="recipe[howtos_attributes][${index}][image]" id="recipe_howtos_attributes_${index}_image">
                    <img class="howto_preview">
                    <textarea rows="6" class="form-control mt-3" id="description" placeholder="100文字以内で説明" name="recipe[howtos_attributes][${index}][description]"></textarea>
                  </div>`;
    return html;
  }

  let fileIndex = [1, 2, 3, 4] // 追加するフォームのインデックス番号を用意
  var lastIndex = $(".js_howto_group:last").data("index"); // 編集フォーム用（すでにデータがある分のインデックス番号が何か取得しておく）
  fileIndex.splice(0, lastIndex); // 編集フォーム用（データがある分のインデックスをfileIndexから除いておく）
  let fileCount = $(".hidden_destroy").length; // 編集フォーム用（データがある分のフォームの数を取得する）
  let displayCount = $(".js_howto_group").length // 見えているフォームの数を取得する
  $(".hidden_destroy").hide(); // 編集フォーム用（削除用のチェックボックスを非表示にしておく）
  if (fileIndex.length == 0) $(".add_btn").css("display","none"); // 編集フォーム用（フォームが５つある場合は追加ボタンを非表示にしておく）

  $(".add_btn").on("click", function() { // 追加ボタンクリックでイベント発火
    $(".howtos_area").append(buildField(fileIndex[0])); // fileIndexの一番小さい数字をインデックス番号に使ってフォームを作成
    fileIndex.shift(); // fileIndexの一番小さい数字を取り除く
    if (fileIndex.length == 0) $(".add_btn").css("display","none"); // フォームが５つになったら追加ボタンを非表示にする
    displayCount += 1; // 見えているフォームの数をカウントアップしておく
  })
});
