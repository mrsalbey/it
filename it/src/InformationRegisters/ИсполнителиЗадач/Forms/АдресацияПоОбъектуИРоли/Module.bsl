
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Роль = Параметры.Роль;
	ОсновнойОбъектАдресации = Параметры.ОсновнойОбъектАдресации;
	Если ОсновнойОбъектАдресации = Неопределено Или ОсновнойОбъектАдресации = "" Тогда
		Элементы.ДополнительныйОбъектАдресации.Видимость = Ложь;
		Элементы.Список.Шапка = Ложь;
		Элементы.ОсновнойОбъектАдресации.Видимость = Ложь;
	Иначе	                                
		Элементы.ОсновнойОбъектАдресации.Заголовок = ОсновнойОбъектАдресации.Метаданные().ПредставлениеОбъекта;
		ДополнительныйОбъектАдресации = Параметры.Роль.ТипыДополнительногоОбъектаАдресации;
		Элементы.ДополнительныйОбъектАдресации.Видимость = НЕ ДополнительныйОбъектАдресации.Пустая();
		Элементы.ДополнительныйОбъектАдресации.Заголовок = ДополнительныйОбъектАдресации.Наименование;
		ТипыДополнительногоОбъектаАдресации = ДополнительныйОбъектАдресации.ТипЗначения;
	КонецЕсли;
	
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Исполнители роли ""%1""'"), Роль);
	
	НаборЗаписейОбъект = РеквизитФормыВЗначение("НаборЗаписей");
	НаборЗаписейОбъект.Отбор.ОсновнойОбъектАдресации.Установить(ОсновнойОбъектАдресации);
	НаборЗаписейОбъект.Отбор.РольИсполнителя.Установить(Роль);
	НаборЗаписейОбъект.Прочитать();
	ЗначениеВРеквизитФормы(НаборЗаписейОбъект, "НаборЗаписей");
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_РолеваяАдресация", ПараметрыЗаписи, НаборЗаписей);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ Список

&НаКлиенте
Процедура СписокПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	Если Роль <> Неопределено Тогда
		Элемент.ТекущиеДанные.РольИсполнителя = Роль;
	КонецЕсли;
	Если ОсновнойОбъектАдресации <> Неопределено Тогда
		Элемент.ТекущиеДанные.ОсновнойОбъектАдресации = ОсновнойОбъектАдресации;
	КонецЕсли;
КонецПроцедуры
                               
&НаКлиенте
Процедура СписокПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если Элементы.ДополнительныйОбъектАдресации.Видимость Тогда
		Элементы.ДополнительныйОбъектАдресации.ОграничениеТипа = ТипыДополнительногоОбъектаАдресации;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Для каждого Значение Из ВыбранноеЗначение Цикл
		Исполнитель = НаборЗаписей.Добавить();
		Исполнитель.Исполнитель = Значение;
		Если Роль <> Неопределено Тогда
			Исполнитель.РольИсполнителя = Роль;
		КонецЕсли;
		Если ОсновнойОбъектАдресации <> Неопределено Тогда
			Исполнитель.ОсновнойОбъектАдресации = ОсновнойОбъектАдресации;
		КонецЕсли;
	КонецЦикла;
	Модифицированность = Истина;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Подобрать(Команда)
	
	ПараметрыФормыВыбора = Новый Структура;
	ПараметрыФормыВыбора.Вставить("ВыборГруппИЭлементов", ИспользованиеГруппИЭлементов.ГруппыИЭлементы);
	ПараметрыФормыВыбора.Вставить("ЗакрыватьПриВыборе", Ложь);
	ПараметрыФормыВыбора.Вставить("ЗакрыватьПриЗакрытииВладельца", Истина);
	ПараметрыФормыВыбора.Вставить("МножественныйВыбор", Истина);
	ПараметрыФормыВыбора.Вставить("РежимВыбора", Истина);
	ПараметрыФормыВыбора.Вставить("ВыборГрупп", Ложь);
	ПараметрыФормыВыбора.Вставить("ВыборГруппПользователей", Ложь);
	
	ОткрытьФорму("Справочник.Пользователи.ФормаВыбора", ПараметрыФормыВыбора, Элементы.Список);
	
КонецПроцедуры

