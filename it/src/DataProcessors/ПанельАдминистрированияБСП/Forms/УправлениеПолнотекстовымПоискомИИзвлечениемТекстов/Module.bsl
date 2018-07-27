&НаКлиенте
Перем ОбновитьИнтерфейс;

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Значения реквизитов формы
	РежимРаботы = ОбщегоНазначенияПовтИсп.РежимРаботыПрограммы();
	РежимРаботы = Новый ФиксированнаяСтруктура(РежимРаботы);
	
	// Значения реквизитов формы
	ИзвлекатьТекстыФайловНаСервере = НаборКонстант.ИзвлекатьТекстыФайловНаСервере;
	
	// Настройки видимости при запуске
	Если РежимРаботы.Файловый Тогда
		Элементы.ГруппаАвтоматическоеИзвлечениеТекстов.Видимость = Ложь;
		АвтоЗаголовок = Ложь;
		Заголовок = НСтр("ru = 'Управление полнотекстовым поиском'");
		Ширина = 40;
	КонецЕсли;
	
	// Обновление состояния элементов
	УстановитьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	ОбновитьИнтерфейсПрограммы();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент)
	
	Результат = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	Если Результат.Свойство("НеУдалосьУстановитьРежимПолнотекстовогоПоиска") Тогда
		// Отмена изменения константы.
		НаборКонстант.ИспользоватьПолнотекстовыйПоиск = НЕ НаборКонстант.ИспользоватьПолнотекстовыйПоиск;
		
		// Выдача предупреждающего сообщения.
		ТекстВопроса = НСтр("ru = 'Для изменения режима полнотекстового поиска требуется завершение сеансов всех пользователей, кроме текущего.'");
		
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(1, НСтр("ru = 'Активные пользователи'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена);
		
		Ответ = Вопрос(ТекстВопроса, Кнопки, , 1);
		Если Ответ = 1 Тогда
			// Устранение проблемы.
			ОткрытьФорму("Обработка.АктивныеПользователи.Форма");
		КонецЕсли;
		
		Возврат;
	КонецЕсли;
	
	#Если НЕ ВебКлиент Тогда
	ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 1, Истина);
	ОбновитьИнтерфейс = Истина;
	#КонецЕсли
	
	СтандартныеПодсистемыКлиент.ПоказатьРезультатВыполнения(ЭтаФорма, Результат);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ОбновитьИндекс(Команда)
	Состояние(
		НСтр("ru = 'Идет обновление полнотекстового индекса...
		|Пожалуйста, подождите.'"));
	
	ОбновитьИндексСервер();
	
	Состояние(НСтр("ru = 'Обновление полнотекстового индекса завершено.'"));
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьИндекс(Команда)
	Состояние(
		НСтр("ru = 'Идет очистка полнотекстового индекса...
		|Пожалуйста, подождите.'"));
	
	ОчиститьИндексСервер();
	
	Состояние(НСтр("ru = 'Очистка полнотекстового индекса завершена.'"));
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьРегламентноеЗадание(Команда)
	ИмяОткрываемойФормы = "Обработка.РегламентныеИФоновыеЗадания.Форма.РегламентноеЗадание";
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Действие", "Изменить");
	ПараметрыФормы.Вставить("Идентификатор", Строка(ИдентификаторПредопределенногоРегламентногоЗадания("ИзвлечениеТекста")));
	
	ВладелецФормы = Неопределено;
	УникальностьФормы = Ложь;
	ОкноФормы = Неопределено;
	
	ОткрытьФорму(ИмяОткрываемойФормы, ПараметрыФормы, ВладелецФормы, УникальностьФормы, ОкноФормы);
КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьИзвлечениеТекстов(Команда)
	Если РежимРаботы.Локальный Или РежимРаботы.Автономный Тогда
		ИмяОткрываемойФормы = "Обработка.АвтоматическоеИзвлечениеТекстов.Форма";
	Иначе
		ИмяОткрываемойФормы = "Обработка.АвтоматическоеИзвлечениеТекстовДляВсехОбластейДанных.Форма";
	КонецЕсли;
	ОткрытьФорму(ИмяОткрываемойФормы);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Служебные процедуры и функции / Вызов сервера

&НаСервере
Процедура ОбновитьИндексСервер()
	ПолнотекстовыйПоиск.ОбновитьИндекс(Ложь, Ложь);
	УстановитьДоступность("Команда.ОбновитьИндекс");
КонецПроцедуры

&НаСервере
Процедура ОчиститьИндексСервер()
	ПолнотекстовыйПоиск.ОчиститьИндекс();
	УстановитьДоступность("Команда.ОчиститьИндекс");
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИдентификаторПредопределенногоРегламентногоЗадания(ИмяПредопределенного)
	МетаданныеПредопределенного = Метаданные.РегламентныеЗадания.Найти(ИмяПредопределенного);
	Если МетаданныеПредопределенного = Неопределено Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Регламентное задание ""%1"" не найдено в метаданных.'"),
			ИмяПредопределенного);
	КонецЕсли;
	
	РегламентноеЗадание = РегламентныеЗадания.НайтиПредопределенное(МетаданныеПредопределенного);
	Если РегламентноеЗадание = Неопределено Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Регламентное задание ""%1"" не найдено.'"),
			ИмяПредопределенного);
	КонецЕсли;
	
	Возврат РегламентноеЗадание.УникальныйИдентификатор;
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции, обслуживающие константы / Клиент

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	#Если НЕ ВебКлиент Тогда
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбновитьПовторноИспользуемыеЗначения();
		ОбновитьИнтерфейс();
	КонецЕсли;
	#КонецЕсли
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции, обслуживающие константы / Вызов сервера

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	Результат = Новый Структура;
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат);
	
	Если Результат.Свойство("НеУдалосьУстановитьРежимПолнотекстовогоПоиска") Тогда
		Возврат Результат;
	КонецЕсли;
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции, обслуживающие константы / Сервер

&НаСервере
Процедура СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	Если РеквизитПутьКДанным = "" Тогда
		Возврат;
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьПолнотекстовыйПоиск" Тогда
		Попытка
			Если НаборКонстант.ИспользоватьПолнотекстовыйПоиск Тогда
				ПолнотекстовыйПоиск.УстановитьРежимПолнотекстовогоПоиска(РежимПолнотекстовогоПоиска.Разрешить);
			Иначе
				ПолнотекстовыйПоиск.УстановитьРежимПолнотекстовогоПоиска(РежимПолнотекстовогоПоиска.Запретить);
			КонецЕсли;
		Исключение
			Результат.Вставить("НеУдалосьУстановитьРежимПолнотекстовогоПоиска", Истина);
			Возврат;
		КонецПопытки;
	КонецЕсли;
	
	// Определение имени константы.
	КонстантаИмя = "";
	Если НРег(Лев(РеквизитПутьКДанным, 14)) = НРег("НаборКонстант.") Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		КонстантаИмя = Сред(РеквизитПутьКДанным, 15);
	Иначе
		// Определение имени и запись значения реквизита в соответствующей константе из "НаборКонстант".
		// Используется для тех реквизитов формы, которые связаны с константами напрямую (в отношении один-к-одному).
		Если РеквизитПутьКДанным = "ИзвлекатьТекстыФайловНаСервере" Тогда
			КонстантаИмя = "ИзвлекатьТекстыФайловНаСервере";
			НаборКонстант.ИзвлекатьТекстыФайловНаСервере = ИзвлекатьТекстыФайловНаСервере;
		КонецЕсли;
	КонецЕсли;
	
	// Сохранения значения константы.
	Если КонстантаИмя <> "" Тогда
		КонстантаМенеджер = Константы[КонстантаИмя];
		КонстантаЗначение = НаборКонстант[КонстантаИмя];
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
		КонецЕсли;
		
		СтандартныеПодсистемыКлиентСервер.РезультатВыполненияДобавитьОповещениеОткрытыхФорм(Результат, "Запись_НаборКонстант", Новый Структура, КонстантаИмя);
		//// СтандартныеПодсистемы.ВариантыОтчетов
		//ВариантыОтчетов.ДобавитьОповещениеПриИзмененииЗначенияКонстанты(Результат, КонстантаМенеджер);
		//// Конец СтандартныеПодсистемы.ВариантыОтчетов
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	Если РеквизитПутьКДанным = "" Тогда
		
		НаборКонстант.ИспользоватьПолнотекстовыйПоиск = (ПолнотекстовыйПоиск.ПолучитьРежимПолнотекстовогоПоиска() = РежимПолнотекстовогоПоиска.Разрешить);
		
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "ИзвлекатьТекстыФайловНаСервере" ИЛИ РеквизитПутьКДанным = "" Тогда
		
		Элементы.ГруппаРедактироватьРегламентноеЗадание.Доступность = НаборКонстант.ИзвлекатьТекстыФайловНаСервере;
		Элементы.ГруппаЗапуститьИзвлечениеТекстов.Доступность = НЕ НаборКонстант.ИзвлекатьТекстыФайловНаСервере;
		
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьПолнотекстовыйПоиск" ИЛИ РеквизитПутьКДанным = "" Тогда
		
		Элементы.ГруппаУправлениеПолнотекстовымПоиском.Доступность = НаборКонстант.ИспользоватьПолнотекстовыйПоиск;
		Элементы.ГруппаАвтоматическоеИзвлечениеТекстов.Доступность = НаборКонстант.ИспользоватьПолнотекстовыйПоиск;
		
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "Команда.ОбновитьИндекс" ИЛИ РеквизитПутьКДанным = "Команда.ОчиститьИндекс" ИЛИ РеквизитПутьКДанным = "" Тогда
		
		//Если НаборКонстант.ИспользоватьПолнотекстовыйПоиск Тогда
		//	ДатаАктуальностиИндекса = ПолнотекстовыйПоиск.ДатаАктуальности();
		//	ИндексАктуален = ПолнотекстовыйПоискСервер.ИндексПоискаАктуален();
		//	ФлагДоступность = НЕ ИндексАктуален;
		//	Если ИндексАктуален Тогда
		//		СтатусИндекса = НСтр("ru = 'Обновление не требуется'");
		//	Иначе
		//		СтатусИндекса = НСтр("ru = 'Требуется обновление'");
		//	КонецЕсли;
		//Иначе
			ДатаАктуальностиИндекса = '00010101';
			ИндексАктуален = Ложь;
			ФлагДоступность = Ложь;
			СтатусИндекса = НСтр("ru = 'Полнотекстовый поиск отключен'");
		//КонецЕсли;
		
		Элементы.ОбновитьИндекс.Доступность = ФлагДоступность;
		
	КонецЕсли;
	
КонецПроцедуры
