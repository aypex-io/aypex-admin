/* eslint-disable no-undef */

import { Application } from '@hotwired/stimulus'

// Stimulus - Aypex Controllers
import BsInstanceController from './bs_instance_controller'
import ClipboardController from './clipboard_controller'
import DomController from './dom_controller'
import FormAutoSaveController from './form/autosave_controller'
import FormStateController from './form/state_controller'
import FormValidationController from './form/validation_controller'
import FormResetController from './form/reset_controller'
import GetIdController from './get_id_controller'
import InputCardFormattingController from './input/card_formatting_controller'
import InputCheckboxState from './input/checkbox_state_controller'
import InputCheckboxValidationController from './input/checkbox_validation_controller'
import InputDatePickerController from './input/datepicker_controller'
import InputDisableController from './input/disable_controller'
import InputFormatDecimalController from './input/format_decimal_controller'
import InputFormatIntegerController from './input/format_integer_controller'
import InputFormattingController from './input/formatting_controller'
import InputNumberIncrementController from './input/number_increment_controller'
import InputRequiredController from './input/required_controller'
import InputValueController from './input/value_controller'
import MenuController from './menu_controller'
import ModalController from './modal_controller'
import PasswordToggleController from './password_toggle_controller'
import Sortable from './sortable/main_controller'
import SortableTreeController from './sortable/tree_controller'
import TipTapEditorController from './tiptap/editor_controller'
import ToastController from './toast_controller'
import TsSearchController from './ts/search_controller'
import TsSelectController from './ts/select_controller'
import TsUserSearchController from './ts/templates/user_controller'
import TsVariantSearchController from './ts/templates/variant_controller'

// Stimulus - Setup
window.Stimulus = Application.start()

Stimulus.register('bs-instance', BsInstanceController)
Stimulus.register('card-formatting', InputCardFormattingController)
Stimulus.register('checkbox-validation', InputCheckboxValidationController)
Stimulus.register('clipboard', ClipboardController)
Stimulus.register('datepicker', InputDatePickerController)
Stimulus.register('dom', DomController)
Stimulus.register('form-state', FormStateController)
Stimulus.register('form-validation', FormValidationController)
Stimulus.register('form-autosave', FormAutoSaveController)
Stimulus.register('form-reset', FormResetController)
Stimulus.register('get-id', GetIdController)
Stimulus.register('input-checkbox-state', InputCheckboxState)
Stimulus.register('input-disable', InputDisableController)
Stimulus.register('input-formatting', InputFormattingController)
Stimulus.register('input-format-decimal', InputFormatDecimalController)
Stimulus.register('input-format-integer', InputFormatIntegerController)
Stimulus.register('input-required', InputRequiredController)
Stimulus.register('input-value', InputValueController)
Stimulus.register('menu', MenuController)
Stimulus.register('modal', ModalController)
Stimulus.register('number-increment', InputNumberIncrementController)
Stimulus.register('password-toggle', PasswordToggleController)
Stimulus.register('sortable', Sortable)
Stimulus.register('sortable-tree', SortableTreeController)
Stimulus.register('toast', ToastController)
Stimulus.register('tiptap-editor', TipTapEditorController)
Stimulus.register('ts-search', TsSearchController)
Stimulus.register('ts-select', TsSelectController)
Stimulus.register('ts-search-user', TsUserSearchController)
Stimulus.register('ts-search-variant', TsVariantSearchController)
