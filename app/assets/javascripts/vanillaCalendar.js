var vanillaCalendar = {
  month: null,
  next: null,
  previous: null,
  label: null,
  activeDates: null,
  date: new Date(),
  todaysDate: new Date(),

  init: function (/*options*/) {
  //  this.options = options
    this.date.setDate(1);
    this.createMonth();
    this.createListeners();
  },

  createListeners: function () {
    var _this = this;
    this.next.addEventListener('click', function () {
      _this.clearCalendar();
      var nextMonth = _this.date.getMonth() + 1;
      _this.date.setMonth(nextMonth);
      _this.createMonth();
    });
    // Clears the calendar and shows the previous month
    this.previous.addEventListener('click', function () {
      _this.clearCalendar();
      var prevMonth = _this.date.getMonth() - 1;
      _this.date.setMonth(prevMonth);
      _this.createMonth();
    });
  },

  createDay: function (num, day, year) {
		var _this = this;
    var newDay = document.createElement('div');
    var dateEl = document.createElement('span');
    dateEl.innerHTML = num;
    newDay.className = 'vcal-date';
		var newFullDate = this.date.getFullYear();
		var newMonth = (this.date.getMonth() + 1).toLocaleString();
		var newDate = this.date.getDate().toLocaleString();
		if (newMonth.length == 1) newFullDate += '0';
		newFullDate += newMonth;
		if (newDate.length == 1) newFullDate += '0';
		newFullDate += newDate;
    newDay.setAttribute('data-calendar-date', newFullDate);
    // if it's the first day of the month
    if (num === 1) {
      if (day === 0) {
        newDay.style.marginLeft = (6 * 14.28) + '%';
      } else {
        newDay.style.marginLeft = ((day - 1) * 14.28) + '%';
      }
    }

    if (/*this.options.disablePastDays &&*/ this.date.getTime() <= this.todaysDate.getTime() - 1) {
      newDay.classList.add('vcal-date--disabled');
    } else {
      newDay.classList.add('vcal-date--active');
      newDay.setAttribute('data-calendar-status', 'active');
			this.isExistSchedule(newFullDate).then(function (data) {
				if (data)
				{
					newDay.setAttribute('data-target', 'patchModal');
					newDay.classList.add('modal-trigger');
					newDay.classList.add('scheduled');
					newDay.addEventListener('click', function () {
						_this.loadSchedule(newFullDate).then(function (data2) {
							var t = $('input[name=title]').eq(1), c = $('textarea[name=content]').eq(1);
							t.val(data2[0].title);
							c.val(data2[0].content);
							M.textareaAutoResize(c);
							M.updateTextFields();
						});
					});
				}
			});
    }

    if (this.date.toString() === this.todaysDate.toString()) {
      newDay.classList.add('vcal-date--today');
    }

    newDay.appendChild(dateEl);
    this.month.appendChild(newDay);
  },
	
	loadSchedule: function(sender) {
		return new Promise(function (resolve, reject) {
			fetch("/schedule/read?fulldate=" + sender, {
				method: "GET",
				dataType : 'json'
			}).then(function(response) {
				if (response.ok) {
					response.json().then(function(data) {
						resolve(data);
					});
				}
			}, function(e) {
				alert("알 수 없는 에러가 발생하였습니다. 상태가 지속된다면 관리자에게 문의하세요!");
			});
		});
	},
	
	isExistSchedule: function(sender) {
		return new Promise(function (resolve, reject) {
			fetch("/schedule/check?fulldate=" + sender, {
				method: "GET",
				dataType : 'json'
			}).then(function(response) {
				if (response.ok) {
					response.json().then(function(data) {
						resolve(data);
					});
				}
			}, function(e) {
				alert("알 수 없는 에러가 발생하였습니다. 상태가 지속된다면 관리자에게 문의하세요!");
			});
		});
	},
	
  dateClicked: function () {
    var _this = this;
    this.activeDates = document.querySelectorAll(
      '[data-calendar-status="active"]'
    );
    for (var i = 0; i < this.activeDates.length; i++) {
      this.activeDates[i].addEventListener('click', function (event) {
        var picked = document.querySelectorAll(
          '[data-calendar-label="picked"]'
        );
				var calendarDate = this.dataset.calendarDate;
				for (var j = 0; j < picked.length; j++) picked[j].value = calendarDate;
				var selected = document.getElementsByClassName('selected-date');
				for (var k = 0; k < selected.length; k++)
					selected[k].innerHTML = calendarDate.slice(0, 4) + '년 ' + calendarDate.slice(4, 6) + '월 ' + calendarDate.slice(6, 8) + '일의';
        _this.removeActiveClass();
        this.classList.add('vcal-date--selected');
				if (this.classList.contains('scheduled') === false) {
						swal({
							title: '해당 일자에는 저장된 일정이 없습니다!',
							text: "새로운 일정을 추가하시겠습니까?",
							type: 'warning',
							showCancelButton: true,
							confirmButtonColor: '#3085d6',
							cancelButtonColor: '#d33',
							confirmButtonText: 'Yes',
							cancelButtonText: 'No',
						}).then((result) => {
							if (result.value) {
								$('#createModal').modal('open');
							}
						});
				}
      });
    }
  },

  createMonth: function () {
    var currentMonth = this.date.getMonth();
    while (this.date.getMonth() === currentMonth) {
      this.createDay(
        this.date.getDate(),
        this.date.getDay(),
        this.date.getFullYear()
      );
      this.date.setDate(this.date.getDate() + 1);
    }
    // while loop trips over and day is at 30/31, bring it back
    this.date.setDate(1);
    this.date.setMonth(this.date.getMonth() - 1);

    this.label.innerHTML =
      this.date.getFullYear() + '년 ' + this.monthsAsString(this.date.getMonth());
    this.dateClicked();
  },

  monthsAsString: function (monthIndex) {
    return [
      '1월',
      '2월',
      '3월',
      '4월',
      '5월',
      '6월',
      '7월',
      '8월',
      '9월',
      '10월',
      '11월',
      '12월'
    ][monthIndex];
  },

  clearCalendar: function () {
    vanillaCalendar.month.innerHTML = '';
  },

  removeActiveClass: function () {
    for (var i = 0; i < this.activeDates.length; i++) {
      this.activeDates[i].classList.remove('vcal-date--selected');
    }
  }
};