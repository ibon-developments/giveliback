import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { BooksComponent } from './books.component';
import {BooksRoutingModule} from './books-routing.module';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';

@NgModule({
  imports: [
    CommonModule,
    BooksRoutingModule,
    FormsModule,
    ReactiveFormsModule
  ],
  exports: [
    BooksComponent,
    FormsModule
  ],
  declarations: [BooksComponent]
})
export class BooksModule { }
