import { TestBed } from '@angular/core/testing';
import { AppComponent } from './app.component';
import { ApiService } from './services/api.service';
import { of, throwError } from 'rxjs';

describe('AppComponent', () => {
  let mockApiService: jasmine.SpyObj<ApiService>;

  beforeEach(() => {
    mockApiService = jasmine.createSpyObj('ApiService', ['getHealth', 'testStudents']);
    mockApiService.getHealth.and.returnValue(of('API OK'));
    mockApiService.testStudents.and.returnValue(of('Students OK'));

    TestBed.configureTestingModule({
      imports: [AppComponent],
      providers: [
        { provide: ApiService, useValue: mockApiService }
      ]
    });
  });

  it('should create the app', () => {
    const fixture = TestBed.createComponent(AppComponent);
    const app = fixture.componentInstance;
    expect(app).toBeTruthy();
  });

  it('should call ApiService.getHealth when testHealth() is triggered', () => {
    const fixture = TestBed.createComponent(AppComponent);
    const app = fixture.componentInstance;

    app.testHealth();
    expect(mockApiService.getHealth).toHaveBeenCalled();
  });

  it('should render title text "GymApp - Web Admin"', () => {
    const fixture = TestBed.createComponent(AppComponent);
    fixture.detectChanges();
    const compiled = fixture.nativeElement as HTMLElement;
    expect(compiled.querySelector('h1')?.textContent).toContain('GymApp - Web Admin');
  });
});
