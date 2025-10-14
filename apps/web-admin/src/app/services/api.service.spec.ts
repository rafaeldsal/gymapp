import { TestBed } from '@angular/core/testing';
import { HttpClientTestingModule, HttpTestingController } from '@angular/common/http/testing';
import { ApiService } from './api.service';

describe('ApiService', () => {
  let service: ApiService;
  let httpMock: HttpTestingController;

  beforeEach(() => {
    TestBed.configureTestingModule({
      imports: [HttpClientTestingModule],
      providers: [ApiService]
    });

    service = TestBed.inject(ApiService);
    httpMock = TestBed.inject(HttpTestingController);
  });

  afterEach(() => {
    httpMock.verify();
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });

  it('should call health endpoint with correct context path', () => {
    const mockResponse = 'API is running! 🏋️';

    service.getHealth().subscribe(response => {
      expect(response).toBe(mockResponse);
    });

    const req = httpMock.expectOne('http://localhost:8080/ws-gymapp/health');
    expect(req.request.method).toBe('GET');
    req.flush(mockResponse);
  });

  it('should call students test endpoint with correct context path', () => {
    const mockResponse = 'Students endpoint working!';

    service.testStudents().subscribe(response => {
      expect(response).toBe(mockResponse);
    });

    const req = httpMock.expectOne('http://localhost:8080/ws-gymapp/api/students/test');
    expect(req.request.method).toBe('GET');
    req.flush(mockResponse);
  });
});