document.addEventListener('turbolinks:load', function() {

  const more_muscle = document.getElementById('more_muscle')
  const main_selection = document.getElementById('main_selection')
  const detail_selection = document.getElementById('detail_selection')
  more_muscle.addEventListener('click', function(){
    main_selection.classList.toggle('toggle_none')
    if (main_selection.classList.contains('toggle_none')){
      more_muscle.innerHTML = '体の部位から選ぶ'
      detail_selection.style.display = 'block'
    } else{
      detail_selection.style.display = 'none'
      more_muscle.innerHTML = '筋肉から選ぶ'
    };
  });
  document.querySelectorAll('.muscle_dropdown').forEach(function(a){
    a.addEventListener('click', function(){
      const muscle_group = a.closest('.muscle_group')
      const dropdown = muscle_group.querySelector('.muscle_dropdown')
      if (muscle_group.classList.contains('muscle_display')){
        a.closest('.muscle_group').querySelector('.muscle_parts').style.display= 'none';
        muscle_group.classList.remove('muscle_display');
        dropdown.innerHTML = '▶'
      } else {
        a.closest('.muscle_group').querySelector('.muscle_parts').style.display= 'block';
        muscle_group.classList.add('muscle_display');
        dropdown.innerHTML = '▼'
      };
    });
  });
  main_selection.addEventListener('change', function(a){
    const main_value = a.target.value;
    if (a.target.checked){
      detail_selection.querySelector(`.check_${main_value}`).checked =true;
    } else{
      detail_selection.querySelector(`.check_${main_value}`).checked =false;
    }
  });
});