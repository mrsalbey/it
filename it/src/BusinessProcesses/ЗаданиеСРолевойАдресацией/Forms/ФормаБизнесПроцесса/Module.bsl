&НаКлиенте
Перем КонтекстВыбора;

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИспользоватьДатуИВремяВСрокахЗадач = ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
	Элементы.Дата.Формат = ?(ИспользоватьДатуИВремяВСрокахЗадач, "ДЛФ=DT", "ДЛФ=D");
	
	Элементы.ГруппаСостояние.Видимость = Объект.Завершен;
	Если Объект.Завершен Тогда
		ДатаЗавершенияСтрокой = ?(ИспользоватьДатуИВремяВСрокахЗадач, 
			Формат(Объект.ДатаЗавершения, "ДЛФ=DT"), Формат(Объект.ДатаЗавершения, "ДЛФ=D"));
		ТекстСостояния = НСтр("ru = 'Задание выполнено %1.'");	
		Элементы.ДекорацияТекст.Заголовок =
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСостояния,	ДатаЗавершенияСтрокой);
			
		Для каждого Элемент Из Элементы Цикл
			Если ТипЗнч(Элемент) <> Тип("ПолеФормы") И ТипЗнч(Элемент) <> Тип("ГруппаФормы") Тогда
				Продолжить;
			КонецЕсли;
			Элемент.ТолькоПросмотр = Истина;
		КонецЦикла;		
	КонецЕсли;
			
	ТипАдресации = ?(Объект.РольИсполнителя.Пустая(), 0, 1);
	ПроверяющийТипАдресации = ?(Объект.РольПроверяющего.Пустая(), 0, 1);
	Элементы.Предмет.Гиперссылка = Объект.Предмет <> Неопределено И НЕ Объект.Предмет.Пустая();
	ПредметСтрокой = ОбщегоНазначения.ПредметСтрокой(Объект.Предмет);	
	НачальныйПризнакСтарта = Объект.Стартован;
	УстановитьСостояниеЭлементов();
	
	Если Объект.ГлавнаяЗадача = Неопределено Или Объект.ГлавнаяЗадача.Пустая() Тогда
		Элементы.ГлавнаяЗадача.Гиперссылка = Ложь;
		ГлавнаяЗадачаСтрокой = НСтр("ru = 'не задана'");
	Иначе	
		ГлавнаяЗадачаСтрокой = Строка(Объект.ГлавнаяЗадача);
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьПодчиненныеБизнесПроцессы") Тогда
		Элементы.ГлавнаяЗадача.Видимость = Ложь;
	КонецЕсли;	
	
	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("ОбщаяФорма.ВыборРолиИсполнителя") Тогда
		
		Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
			Если КонтекстВыбора = "РольНажатие" Тогда
				УстановитьРоль(ВыбранноеЗначение);
			ИначеЕсли КонтекстВыбора = "РольПроверяющегоНажатие" Тогда
				УстановитьРольПроверяющего(ВыбранноеЗначение);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Проверяем заполнение во всех случаях при записи, а не только при старте.
	Если НачальныйПризнакСтарта И ТекущийОбъект.Стартован ИЛИ 
		(НЕ НачальныйПризнакСтарта И НЕ ТекущийОбъект.Стартован) Тогда
		
		Если Не ТекущийОбъект.ПроверитьЗаполнение() Тогда
			Отказ = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ГлавнаяЗадачаНажатие(Элемент, СтандартнаяОбработка)
	
	Если Не БизнесПроцессыИЗадачиКлиент.ОткрытьФормуВыполненияЗадачи(Объект.ГлавнаяЗадача) Тогда
		ОткрытьЗначение(Объект.ГлавнаяЗадача);
	КонецЕсли;
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура РольНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	КонтекстВыбора = "РольНажатие";
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РольИсполнителя", Объект.РольИсполнителя);
	ПараметрыФормы.Вставить("ОсновнойОбъектАдресации", Объект.ОсновнойОбъектАдресации);
	ПараметрыФормы.Вставить("ДополнительныйОбъектАдресации", Объект.ДополнительныйОбъектАдресации);
	
	ОткрытьФорму("ОбщаяФорма.ВыборРолиИсполнителя", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметНажатие(Элемент, СтандартнаяОбработка)
	Если ТипЗнч(Объект.Предмет) = Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда
		БизнесПроцессыИЗадачиКлиент.ОткрытьФормуВыполненияЗадачи(Объект.Предмет);
	Иначе	
		ОткрытьЗначение(Объект.Предмет);
	КонецЕсли;
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура РольПроверяющегоНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	КонтекстВыбора = "РольПроверяющегоНажатие";
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РольИсполнителя", Объект.РольПроверяющего);
	ПараметрыФормы.Вставить("ОсновнойОбъектАдресации", Объект.ОсновнойОбъектАдресацииПроверяющий);
	ПараметрыФормы.Вставить("ДополнительныйОбъектАдресации", Объект.ДополнительныйОбъектАдресацииПроверяющий);
	
	ОткрытьФорму("ОбщаяФорма.ВыборРолиИсполнителя", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительПриИзменении(Элемент)
	ТипАдресации = 0;
	Объект.РольИсполнителя = Неопределено;
	Объект.ОсновнойОбъектАдресации = Неопределено;
	Объект.ДополнительныйОбъектАдресации = Неопределено;
	РольСтрокой = НСтр("ru = 'Не указана'");
КонецПроцедуры

&НаКлиенте
Процедура ПроверяющийПриИзменении(Элемент)
	ПроверяющийТипАдресации = 0;
	Объект.РольПроверяющего = Неопределено;
	Объект.ОсновнойОбъектАдресацииПроверяющий = Неопределено;
	Объект.ДополнительныйОбъектАдресацииПроверяющий = Неопределено;
	РольПроверяющегоСтрокой = НСтр("ru = 'Не указана'");
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВыполнениеПриИзменении(Элемент)
	УстановитьСостояниеЭлементов();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	
	Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтаФорма, Команда.Имя) Тогда
		РезультатВыполнения = Неопределено;
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
		ДополнительныеОтчетыИОбработкиКлиент.ПоказатьРезультатВыполненияКоманды(ЭтаФорма, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаСервере
Процедура УстановитьРоль(РольСтруктура)
	Объект.Исполнитель = Справочники.Пользователи.ПустаяСсылка();
	Объект.РольИсполнителя = РольСтруктура.РольИсполнителя;
	Объект.ОсновнойОбъектАдресации = РольСтруктура.ОсновнойОбъектАдресации;
	Объект.ДополнительныйОбъектАдресации = РольСтруктура.ДополнительныйОбъектАдресации;
	УстановитьСостояниеЭлементов();
	ТипАдресации = 1;
КонецПроцедуры	

&НаСервере
Процедура УстановитьРольПроверяющего(РольСтруктура)
	Объект.Проверяющий = Справочники.Пользователи.ПустаяСсылка();
	Объект.РольПроверяющего = РольСтруктура.РольИсполнителя;
	Объект.ОсновнойОбъектАдресацииПроверяющий = РольСтруктура.ОсновнойОбъектАдресации;
	Объект.ДополнительныйОбъектАдресацииПроверяющий = РольСтруктура.ДополнительныйОбъектАдресации;
	УстановитьСостояниеЭлементов();
	ПроверяющийТипАдресации = 1;
КонецПроцедуры	

&НаСервере
Процедура УстановитьСостояниеЭлементов()
	РольСтрокой = БизнесПроцессыИЗадачиСервер.РольСтрокой(
		Объект.РольИсполнителя, Объект.ОсновнойОбъектАдресации,
		Объект.ДополнительныйОбъектАдресации);
	РольПроверяющегоСтрокой = БизнесПроцессыИЗадачиСервер.РольСтрокой(
		Объект.РольПроверяющего, Объект.ОсновнойОбъектАдресацииПроверяющий,
		Объект.ДополнительныйОбъектАдресацииПроверяющий);
	Элементы.ГруппаПроверка.Доступность = Объект.ПроверитьВыполнение;
	
КонецПроцедуры	

&НаКлиенте
Процедура ИсполнительАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда 
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = БизнесПроцессыИЗадачиВызовСервера.СформироватьДанныеВыбораИсполнителя(Текст);
	КонецЕсли;	
	
КонецПроцедуры
