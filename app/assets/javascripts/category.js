document.addEventListener('turbolinks:load', function() {

  const more_muscle = document.getElementById('more_muscle')
  const main_selection = document.getElementById('main_selection')
  const detail_selection = document.getElementById('detail_selection')
  more_muscle.addEventListener('click', function(){
    main_selection.classList.toggle('toggle_none');
    if (main_selection.classList.contains('toggle_none')){
      more_muscle.innerHTML = '体の部位から選ぶ';
      detail_selection.style.display = 'block';
      document.querySelectorAll('.muscle_target_checkbox').forEach(function(a){
        if(a.checked){
          const muscle_group = a.closest('.muscle_group')
          a.closest('.muscle_target').style.display = 'block';
          muscle_group.classList.add('muscle_display');
          muscle_group.querySelector('.muscle_dropdown').innerHTML = '▼';
        };
      });
    } else {
      detail_selection.style.display = 'none';
      more_muscle.innerHTML = '筋肉から選ぶ';
    };
  });

  document.querySelectorAll('.muscle_dropdown').forEach(function(a){
    a.addEventListener('click', function(){
      const muscle_group = a.closest('.muscle_group')
      const dropdown = muscle_group.querySelector('.muscle_dropdown')
      const muscle_target = a.closest('.muscle_group').querySelector('.muscle_target')
      if (muscle_group.classList.contains('muscle_display')){
        muscle_target.style.display= 'none';
        muscle_group.classList.remove('muscle_display');
        dropdown.innerHTML = '▶'
      } else {
        muscle_target.style.display= 'block';
        muscle_group.classList.add('muscle_display');
        dropdown.innerHTML = '▼'
      };
    });
  });

  //チェックボックス連動
  main_selection.addEventListener('change', function(a){
    const main_value = a.target.value;
    if (a.target.checked){
      detail_selection.querySelector(`.check_${main_value}`).checked =true;
    } else{
      detail_selection.querySelector(`.check_${main_value}`).checked =false;
    }
  });
  detail_selection.addEventListener('change', function(a){
    const detail_value = a.target.value;
    if (a.target.checked){
      main_selection.querySelector(`.check_${detail_value}`).checked =true;
    } else{
      main_selection.querySelector(`.check_${detail_value}`).checked =false;
    }
  });
});